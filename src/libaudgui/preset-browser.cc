/*
 * preset-browser.c
 * Copyright 2014-2015 John Lindgren
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions, and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions, and the following disclaimer in the documentation
 *    provided with the distribution.
 *
 * This software is provided "as is" and without any warranty, express or
 * implied. In no event shall the authors be liable for any damages arising from
 * the use of this software.
 */

#define AUD_GLIB_INTEGRATION
#include "internal.h"
#include "libaudgui.h"
#include "preset-browser.h"

#include <string.h>
#include <gtk/gtk.h>

#include <libaudcore/audstrings.h>
#include <libaudcore/drct.h>
#include <libaudcore/equalizer.h>
#include <libaudcore/i18n.h>
#include <libaudcore/vfs.h>
#include <libaudcore/playlist.h>
#include <libaudcore/runtime.h>

typedef void (* FilebrowserCallback) (const char * filename);
#ifdef _WIN32
    static const char * path_sep = "\\";
#else
    static const char * path_sep = "/";
#endif

static void browser_response (GtkWidget * dialog, int response, void * data)
{
    if (response == GTK_RESPONSE_ACCEPT)
    {
        CharPtr filename (gtk_file_chooser_get_uri ((GtkFileChooser *) dialog));
        ((FilebrowserCallback) data) (filename);
    }

    gtk_widget_destroy (dialog);
}

static void show_preset_browser (const char * title, gboolean save,
 const char * default_filename, FilebrowserCallback callback)
{
    GtkFileFilter * filter;

    GtkWidget * browser = gtk_file_chooser_dialog_new (title, nullptr, save ?
     GTK_FILE_CHOOSER_ACTION_SAVE : GTK_FILE_CHOOSER_ACTION_OPEN, _("Cancel"),
     GTK_RESPONSE_CANCEL, save ? _("Save") : _("Load"), GTK_RESPONSE_ACCEPT,
     nullptr);
    filter = gtk_file_filter_new ();
    gtk_file_filter_set_name (filter, _("Preset/Eq Files"));
    gtk_file_filter_add_pattern (filter, _("*.preset"));
    gtk_file_filter_add_pattern (filter, _("*.eqf"));
    gtk_file_filter_add_pattern (filter, _("*.q1"));
    gtk_file_chooser_add_filter ((GtkFileChooser *) browser, filter);
    gtk_file_chooser_set_current_folder_uri ((GtkFileChooser *) browser,
            filename_to_uri (aud_get_path (AudPath::UserDir)));
    gtk_file_chooser_set_local_only ((GtkFileChooser *) browser, false);

    if (default_filename)
        gtk_file_chooser_set_current_name ((GtkFileChooser *) browser, default_filename);

    g_signal_connect (browser, "response", (GCallback) browser_response, (void *) callback);

    audgui_show_unique_window (AUDGUI_PRESET_BROWSER_WINDOW, browser);
}

static void do_load_file (const char * filename)
{
    EqualizerPreset preset;

    VFSFile file (filename, "r");
    if (! file || ! aud_load_preset_file (preset, file))
        return;

    aud_eq_apply_preset (preset);
}

void eq_preset_load_file ()
{
    show_preset_browser (_("Load Preset File"), false, nullptr, do_load_file);
}

static void do_load_eqf (const char * filename)
{
    VFSFile file (filename, "r");
    if (! file)
        return;

    Index<EqualizerPreset> presets = aud_import_winamp_presets (file);

    if (presets.len ())
        aud_eq_apply_preset (presets[0]);
}

void eq_preset_load_eqf ()
{
    show_preset_browser (_("Load EQF File"), false, nullptr, do_load_eqf);
}

static void do_save_file (const char * filename)
{
    EqualizerPreset preset;
    aud_eq_update_preset (preset);

    VFSFile file (filename, "w");
    if (file)
    {
        aud_save_preset_file (preset, file);

        // JWT:IF [Auto] IS ON && FILENAME SAVED == SONG AUTO (DEFAULT) PATH/SONGNAME.preset, LIGHT UP THE 
        // [PRESET] BUTTON INDICATING SONG-SPECIFIC EQUALIZATION IS IN EFFECT!
        // JWT:YES, WE *DO* HAVE TO CALL str_decode_percent *TWICE* SINCE IT GETS ENCODED TWICE SOMETIMES IN THE PROCESS!

        if (aud_get_bool (nullptr, "equalizer_autoload") 
                && ! strcmp((const char *) str_decode_percent (aud_get_str(nullptr, "eq_last_preset_filename"),-1), 
                (const char *) str_decode_percent ((const char *) str_decode_percent (filename),-1)))
        {
            aud_set_bool(nullptr, "equalizer_songauto", true);
            aud_set_str(nullptr, "eq_last_preset_filename", "");
        }
    }
}

void eq_preset_save_file ()
{
    String filename;
    aud_set_str(nullptr, "eq_last_preset_filename", "");
    int current_playlist = aud_playlist_get_playing ();
    if (current_playlist >= 0)
    {
        int current_song = aud_playlist_get_position (current_playlist);
        if (current_song >= 0)
        {
            const char * slash;
            const char * base;
            filename = aud_playlist_entry_get_filename (current_playlist, current_song);
            const char * dross = aud_get_bool (nullptr, "eqpreset_nameonly") ? strstr (filename, "?") : nullptr;
            int ln = -1;
            slash = filename ? strrchr (filename, '/') : nullptr;
            if (slash && dross && slash > dross)
            {
                slash = dross;
                while (slash > filename && slash[0] != '/')
                {
                    --slash;
                }
                if (slash[0] != '/')
                    slash = nullptr;
            }        	   	   
            base = slash ? slash + 1 : nullptr;
            if (slash && (!base || base[0] == '\0')) // FILENAME ENDS IN A "/"!
            {
                do
                {
                    --slash;
                    ++ln;
                } while (slash && slash > filename && slash[0] != '/');
                base = slash ? slash + 1 : nullptr;
                if (ln > 0)
                {
                    aud_set_str (nullptr, "eq_last_preset_filename", String (filename_to_uri (String (str_printf("%s%s%.*s%s",
                    aud_get_path (AudPath::UserDir), path_sep, ln, base, ".preset")))));
                    show_preset_browser (_("Save Preset File"), true,
                    String (str_encode_percent (str_printf("%.*s%s", ln, base, ".preset"),-1)), do_save_file);
                    return;
                }
            }
            else if (base && base[0] != '\0' && strncmp (base, "-.", 2))
            {
                const char * iscue = dross ? dross : strstr (filename, "?");
                if (iscue)
                {
                    /* JWT:SONGS FROM CUE FILES HAVE A TRAILING "?<cue#>" THAT'S NOT ON THE FILENAME IN output.cc 
                    SO WE HAVE TO STRIP IT OFF THE "filename" HERE, BUT ONLY IF WE'RE A "file://..." SCHEME, 
                    LEST WE WHACK OFF A URL LIKE "https://www.youtube.com/watch?t=4&v=BaW_jenozKc"!
                    THE DRAWBACK W/THIS IS THAT ALL CUES OF THE SAME BASE FILE NAME WILL HAVE THE SAME 
                    EQ. PRESET, BUT THE ALTERNATIVE IS THAT EQ. PRESETS WON'T WORK AT ALL FOR CUE-BASED 
                    FILES, SINCE WE DON'T SEEM TO HAVE THE <cue#> IN output.cc for output_open_audio()!
                    */
                    StringBuf scheme = uri_get_scheme ((const char *) filename);
                    if (dross || ! strcmp (scheme, "file"))
                    {
                        int ln = iscue - base;
                        aud_set_str (nullptr, "eq_last_preset_filename", String (filename_to_uri (String (str_printf ("%s%s%.*s%s",
                        aud_get_path (AudPath::UserDir), path_sep, ln, base, ".preset")))));
                        show_preset_browser (_("Save Preset File"), true,
                                String (str_encode_percent (str_printf ("%.*s%s", ln, base, ".preset"),-1)), 
                        do_save_file);
                        return;
                    }
                }
                aud_set_str(nullptr, "eq_last_preset_filename", String (filename_to_uri (String (str_printf ("%s%s%s%s",
                aud_get_path (AudPath::UserDir), path_sep, base, ".preset")))));
                show_preset_browser (_("Save Preset File"), true,
                String (str_encode_percent (str_printf ("%s%s", base, ".preset"),-1)), do_save_file);
                return;
            }
        }
    }
    show_preset_browser (_("Save Preset File"), true, _("<name>.preset"), do_save_file);
}

static void do_save_eqf (const char * filename)
{
    VFSFile file (filename, "w");
    if (! file)
        return;

    EqualizerPreset preset = EqualizerPreset ();
    preset.name = String ("Preset1");

    aud_eq_update_preset (preset);
    aud_export_winamp_preset (preset, file);
}

void eq_preset_save_eqf ()
{
    show_preset_browser (_("Save EQF File"), true, _("<name>.eqf"), do_save_eqf);
}

static void do_import_winamp (const char * filename)
{
    VFSFile file (filename, "r");
    if (! file)
        return;

    audgui_import_eq_presets (aud_import_winamp_presets (file));
}

void eq_preset_import_winamp ()
{
    show_preset_browser (_("Import Winamp Presets"), false, nullptr, do_import_winamp);
}

static const char norm_fg[] = "#8ae1c1";
static const char norm_bg[] = "#0F161E";
static const char norm_border[] = "#609d87";

static const char sel_fg[] = "#8ae1c1";
static const char sel_bg[] = "#595A59";
static const char sel_border[] = "#8ae1c1";

static const char urg_fg[] = "#8ae1c1";
static const char urg_bg[] = "#32514E";
static const char urg_border[] = "#32514E";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

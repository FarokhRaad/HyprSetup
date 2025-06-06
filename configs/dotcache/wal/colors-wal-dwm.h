static const char norm_fg[] = "#dcd1cd";
static const char norm_bg[] = "#0C1C29";
static const char norm_border[] = "#9a928f";

static const char sel_fg[] = "#dcd1cd";
static const char sel_bg[] = "#9A6861";
static const char sel_border[] = "#dcd1cd";

static const char urg_fg[] = "#dcd1cd";
static const char urg_bg[] = "#5F5B69";
static const char urg_border[] = "#5F5B69";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};

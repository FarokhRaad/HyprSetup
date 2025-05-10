const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0C1C29", /* black   */
  [1] = "#5F5B69", /* red     */
  [2] = "#9A6861", /* green   */
  [3] = "#657389", /* yellow  */
  [4] = "#A38181", /* blue    */
  [5] = "#B09D9B", /* magenta */
  [6] = "#CE978E", /* cyan    */
  [7] = "#dcd1cd", /* white   */

  /* 8 bright colors */
  [8]  = "#9a928f",  /* black   */
  [9]  = "#5F5B69",  /* red     */
  [10] = "#9A6861", /* green   */
  [11] = "#657389", /* yellow  */
  [12] = "#A38181", /* blue    */
  [13] = "#B09D9B", /* magenta */
  [14] = "#CE978E", /* cyan    */
  [15] = "#dcd1cd", /* white   */

  /* special colors */
  [256] = "#0C1C29", /* background */
  [257] = "#dcd1cd", /* foreground */
  [258] = "#dcd1cd",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

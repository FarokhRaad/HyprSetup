const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0F161E", /* black   */
  [1] = "#32514E", /* red     */
  [2] = "#595A59", /* green   */
  [3] = "#B85154", /* yellow  */
  [4] = "#30A95B", /* blue    */
  [5] = "#B6A743", /* magenta */
  [6] = "#94439B", /* cyan    */
  [7] = "#8ae1c1", /* white   */

  /* 8 bright colors */
  [8]  = "#609d87",  /* black   */
  [9]  = "#32514E",  /* red     */
  [10] = "#595A59", /* green   */
  [11] = "#B85154", /* yellow  */
  [12] = "#30A95B", /* blue    */
  [13] = "#B6A743", /* magenta */
  [14] = "#94439B", /* cyan    */
  [15] = "#8ae1c1", /* white   */

  /* special colors */
  [256] = "#0F161E", /* background */
  [257] = "#8ae1c1", /* foreground */
  [258] = "#8ae1c1",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

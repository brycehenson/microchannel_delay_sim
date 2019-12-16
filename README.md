# MicroChannel Plate Delay
Calculating MCP timing spread for slow particles based on geometric calculations.
**Bryce M. Henson**

This code presents the distribution of detection times for slowly moving particles that are detected with a a type of 2d electron multiplier known as a MicroChannel Plate (MCP) (aka. Multi Channel Plate),  The delays are derived using a geometric model that considers the pore as a cylinder and the MCP front face as perfectly flat. I present two parts to this code: a numerical simulation of the propagation time in Matlab, and an analytic derivation in Mathematica. This project was started to predict the temporal resolution of delays in a metastable helium cold atom experiment.

| <img src="/figs/mcp_pore_delay_side_top_view.png" alt="Schematic" width="400" align="middle"> | 
|:--:| 
 **Figure 1**- The Metastable Helium atoms have a varied propagation distance from the surface of the MCP until they strike on the side of the slanted MCP holes. |
 
| ![Ray Tracing](/figs/ray_diagram.png) | 
|:--:| 
 **Figure 2**- Ray tracing allows the distribution to be approximated and to verify the analytical treatment. |

| <img src="/figs/mcp_delay_combined_functions_plot.png" alt="Distribution" width="400" align="middle"> | 
|:--:| 
 **Figure 3**- The derived distributions a) probability distribution function. b) cumulative distribution function c) two sample difference distribution. |
 

## TODO
This project is generally regarded as complete. However there are a few small things to do
- add the explanation and equations to this readme (from thesis appendix)
- try to publish this derivation as a note
- derive the j-sample difference distribution


## Contributions  
This project would not have been possible without the many open source tools that it is based on. In no particular order: 

* ***James Conder*** [gaussfilt](https://au.mathworks.com/matlabcentral/fileexchange/43182-gaussfilt-t-z-sigma)
* ***Patrick Egan*** [fwhm](https://au.mathworks.com/matlabcentral/fileexchange/10590-fwhm)
* ***Yair Altman*** [export_fig](https://github.com/altmany/export_fig)

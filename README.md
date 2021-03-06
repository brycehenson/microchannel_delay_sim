# MicroChannel (MultiChannel) Plate Delay
**[Bryce M. Henson](https://github.com/brycehenson)**  
Calculating MCP timing spread for slow particles based on geometric calculations.  


This code presents the distribution of detection times for slowly moving (neutral) particles that are detected with a a type of 2d electron multiplier known as a MicroChannel Plate (MCP) (aka. Multi Channel Plate). The delays arise from the finite propagation time into the detection pore before they cause an electron cascade.  The delays are derived using a geometric model that considers the pore as a cylinder and the MCP front face as perfectly flat. I present two parts to this code: a numerical simulation of the propagation time in Matlab, and an analytic derivation in Mathematica. This project was started to predict the temporal resolution of delays in a metastable helium cold atom experiment.

| <img src="/figs/mcp_pore_delay_side_top_view.png" alt="Schematic" width="700" align="middle"> | 
|:--:| 
 **Figure 1**- A) Side View: The Metastable Helium atoms have a varied propagation distance from the surface of the MCP until they strike on the side of the slanted MCP holes. B) Top View: The entrance aperture is shown as green solid line and the ellipse corresponding to the input positions in x,y to give a delay t are shown in blue dashed line. The cumulative distribution function (CDF) at time t is found by calculating the shaded area between the two ellipses (which are the same function translated by Δy).  |
 
|  <img src="/figs/ray_diagram.png" alt="Ray Tracing" width="400" align="middle">  | 
|:--:| 
 **Figure 2**- Ray tracing allows the distribution to be approximated and to verify the analytical treatment. |


 ## Results
 
| <img src="/figs/mcp_delay_combined_functions_plot.png" alt="Distribution" width="700" align="middle"> | 
|:--:| 
 **Figure 3**- The derived distributions of delays relative to the front face of the MCP. a) probability distribution function. b) cumulative distribution function c) two sample difference distribution (solid brown line) with  triangular aproximation shown (ashed light blue line). |
 
In the worst case this delay will be  
<img src="/figs/eq/tmax.png" alt="t_max" width="200" align="middle">  
where \alpha is the pore angle to vertical, r_pore is the pore radius and v is the velocity at the detector.  
The PDF is found to be  
<img src="/figs/eq/pdf.png" alt="pdf" width="400" align="middle">  
with mean ≈0.4244·t_max and standard deviation ≈0.2643·t_max.    
The corresponding CDF is  
<img src="/figs/eq/cdf.png" alt="cdf" width="500" align="middle">  
with median t_delay≈0.4039.
The two sample difference distribution is  
<img src="/figs/eq/2sample_diff_dist.png" alt="2sample_diff_dist" width="500" align="middle">  
which uses the elliptic integerals defined as :  
<img src="/figs/eq/elliptic_int_def.png" alt="elliptic_int_def" width="300" align="middle">  
. The two sample difference distribution has standard deviation 0.3738·t_max and FWHM of 0.9113·t_max. It is reasonably aproximated by the tirangle function  
<img src="/figs/eq/tirangle_fun.png" alt="tirangle_fun" width="350" align="middle">  
where H is the unit step function and s is a sale factor which produces the best RMSE to the true difference distribution when equal to 1.1050.
 
 
## TODO
This project is generally regarded as complete. However there are a few small things to do
- add to this readme from thesis appendix
  - [ ] explanation 
  - [x] equations 
- [ ] try to publish this derivation as a note
- [ ] derive the j-sample difference distribution


## Contributions  
This project would not have been possible without the many open source tools that it is based on. In no particular order: 

* ***James Conder*** [gaussfilt](https://au.mathworks.com/matlabcentral/fileexchange/43182-gaussfilt-t-z-sigma)
* ***Patrick Egan*** [fwhm](https://au.mathworks.com/matlabcentral/fileexchange/10590-fwhm)
* ***Yair Altman*** [export_fig](https://github.com/altmany/export_fig)

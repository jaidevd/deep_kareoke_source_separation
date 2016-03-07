Deep Karaoke source code
========================
This package contains the code for comparing the neural network and supervised nmf audio source separation methods as described in our article:

A. J. Simpson, G. Roma and M.D. Plumbley, "Deep Karaoke: Extracting Vocals from Musical Mixtures Using a Convolutional Deep Neural Network," in Proceedings of the International Conference on Latent Variable Analysis and Signal Separation (LVA/ICA), Liberec, Czech Republic, 2015, 429-436.

Please cite it if you use this code.

**Requirements:**
- Matlab 2014
- Matlab toolboxes: jsonlab, Deep Learning Toolbox[1], BSSEval
- Lots of RAM and patience.

[1] R. B. Palm, "Prediction as a candidate for learning deep hierarchical models of data". Master thesis. 2012. (Note that we made a slight modification on the sigmoid function, as noted in the paper. This change is reflected in the file dk_dl_toolbox.diff).

To get started open test.m
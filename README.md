# When androids dream...

Neural network-based image style transfer using the [neural-style](https://github.com/jcjohnson/neural-style) library

![screenshot](/screenshot.png)

## Set-up

This library is a simple Rails-based web application allowing a user to upload images and select images to be stylistically blended.

The heavy lifting is performed by another server, which must have [neural-style](https://github.com/jcjohnson/neural-style) installed.

By default, the following are assumed:
* The image-processing server has neural-style installed to the directory ```/home/ubuntu/Code/neural-style```
  * Walk through the full installation guide [here](https://github.com/jcjohnson/neural-style/blob/master/INSTALL.md]).
* The webserver has SSH access to the server, aliased by the name **neuralstyle**

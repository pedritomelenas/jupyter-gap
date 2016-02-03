# jupyter-gap
Jupyter kernels for GAP

Please note that this software is still in the early stages of development and names of kernels, assumptions,
and architecture might change on a day-to-day basis without notice.

## wrapper-kernel

The `wrapper-kernel' is a Jupyter kernel based on the [bash wrapper kernel](https://github.com/takluyver/bash_kernel),
to install

```shell
    python setup.py install
    python -m jupyter_gap_wrapper.install
```

To use it, use one of the following:

```shell
    ipython notebook
    ipython qtconsole --kernel gap
    ipython console --kernel gap
```

Note that this kernel assumes that `gap.sh` is in the `PATH`.

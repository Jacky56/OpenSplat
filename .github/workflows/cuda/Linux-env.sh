#!/bin/bash

# Took from https://github.com/pyg-team/pyg-lib/

case ${1} in
  cu121)
    export CUDA_HOME=/usr/local/cuda-12.1
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-12.1/bin/nvcc
    ;;
  cu118)
    export CUDA_HOME=/usr/local/cuda-11.8
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-11.8/bin/nvcc

    ;;
  cu117)
    export CUDA_HOME=/usr/local/cuda-11.7
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-11.7/bin/nvcc
    ;;
  cu116)
    export CUDA_HOME=/usr/local/cuda-11.6
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-11.6/bin/nvcc
    ;;
  cu115)
    export CUDA_HOME=/usr/local/cuda-11.5
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-11.5/bin/nvcc
    ;;
  cu113)
    export CUDA_HOME=/usr/local/cuda-11.3
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-11.3/bin/nvcc
    ;;
  cu102)
    export CUDA_HOME=/usr/local/cuda-10.2
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    export CUDACXX=/usr/local/cuda-10.2/bin/nvcc
    ;;
  *)
    ;;
esac
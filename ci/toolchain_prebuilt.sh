#!/bin/bash

# Copyright © 2019-2023
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# exit when any command fails
set -e

<<<<<<< HEAD
TOOLDIR=${TOOLDIR:=/opt}
OSDIR=${OSDIR:=ubuntu/bionic}
=======
OS_DIR=${OS_DIR:-'ubuntu/bionic'}
SRCDIR=${SRCDIR:-'/opt'}
DESTDIR=${DESTDIR:-'.'}

echo "OS_DIR=${OS_DIR}"
echo "SRCDIR=${SRCDIR}"
echo "DESTDIR=${DESTDIR}"
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b

riscv() 
{
    echo "prebuilt riscv-gnu-toolchain..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf riscv-gnu-toolchain.tar.bz2 riscv-gnu-toolchain
    split -b 50M riscv-gnu-toolchain.tar.bz2 "riscv-gnu-toolchain.tar.bz2.part"    
    mv riscv-gnu-toolchain.tar.bz2.part* ./riscv-gnu-toolchain/$OSDIR
=======
    tar -C $SRCDIR -cvjf riscv-gnu-toolchain.tar.bz2 riscv-gnu-toolchain
    split -b 50M riscv-gnu-toolchain.tar.bz2 "riscv-gnu-toolchain.tar.bz2.part"    
    mv riscv-gnu-toolchain.tar.bz2.part* $DESTDIR/riscv-gnu-toolchain/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
    rm riscv-gnu-toolchain.tar.bz2
}

riscv64() 
{
    echo "prebuilt riscv64-gnu-toolchain..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf riscv64-gnu-toolchain.tar.bz2 riscv64-gnu-toolchain
    split -b 50M riscv64-gnu-toolchain.tar.bz2 "riscv64-gnu-toolchain.tar.bz2.part"    
    mv riscv64-gnu-toolchain.tar.bz2.part* ./riscv64-gnu-toolchain/$OSDIR
=======
    tar -C $SRCDIR -cvjf riscv64-gnu-toolchain.tar.bz2 riscv64-gnu-toolchain
    split -b 50M riscv64-gnu-toolchain.tar.bz2 "riscv64-gnu-toolchain.tar.bz2.part"    
    mv riscv64-gnu-toolchain.tar.bz2.part* $DESTDIR/riscv64-gnu-toolchain/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
    rm riscv64-gnu-toolchain.tar.bz2
}

llvm-vortex() 
{
    echo "prebuilt llvm-vortex..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf llvm-vortex.tar.bz2 llvm-vortex
    split -b 50M llvm-vortex.tar.bz2 "llvm-vortex.tar.bz2.part"    
    mv llvm-vortex.tar.bz2.part* ./llvm-vortex/$OSDIR
=======
    tar -C $SRCDIR -cvjf llvm-vortex.tar.bz2 llvm-vortex
    split -b 50M llvm-vortex.tar.bz2 "llvm-vortex.tar.bz2.part"    
    mv llvm-vortex.tar.bz2.part* $DESTDIR/llvm-vortex/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
    rm llvm-vortex.tar.bz2
}

llvm-pocl() 
{
    echo "prebuilt llvm-pocl..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf llvm-pocl.tar.bz2 llvm-pocl
    split -b 50M llvm-pocl.tar.bz2 "llvm-pocl.tar.bz2.part"    
    mv llvm-pocl.tar.bz2.part* ./llvm-pocl/$OSDIR
=======
    tar -C $SRCDIR -cvjf llvm-pocl.tar.bz2 llvm-pocl
    split -b 50M llvm-pocl.tar.bz2 "llvm-pocl.tar.bz2.part"    
    mv llvm-pocl.tar.bz2.part* $DESTDIR/llvm-pocl/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
    rm llvm-pocl.tar.bz2
}

pocl() 
{
    echo "prebuilt pocl..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf pocl.tar.bz2 pocl
    mv pocl.tar.bz2 ./pocl/$OSDIR
=======
    tar -C $SRCDIR -cvjf pocl.tar.bz2 pocl
    mv pocl.tar.bz2 $DESTDIR/pocl/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
}

verilator() 
{
    echo "prebuilt verilator..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf verilator.tar.bz2 verilator
    mv verilator.tar.bz2 ./verilator/$OSDIR
=======
    tar -C $SRCDIR -cvjf verilator.tar.bz2 verilator
    mv verilator.tar.bz2 $DESTDIR/verilator/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
}

sv2v() 
{
    echo "prebuilt sv2v..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf sv2v.tar.bz2 sv2v
    mv sv2v.tar.bz2 ./sv2v/$OSDIR
=======
    tar -C $SRCDIR -cvjf sv2v.tar.bz2 sv2v
    mv sv2v.tar.bz2 $DESTDIR/sv2v/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
}

yosys()
{
    echo "prebuilt yosys..."
<<<<<<< HEAD
    tar -C $TOOLDIR -cvjf yosys.tar.bz2 yosys
    split -b 50M yosys.tar.bz2 "yosys.tar.bz2.part"    
    mv yosys.tar.bz2.part* ./yosys/$OSDIR
=======
    tar -C $SRCDIR -cvjf yosys.tar.bz2 yosys
    split -b 50M yosys.tar.bz2 "yosys.tar.bz2.part"    
    mv yosys.tar.bz2.part* $DESTDIR/yosys/$OS_DIR
>>>>>>> 47b5f0545a5746524287aeb535791edc465b295b
    rm yosys.tar.bz2
}

show_usage()
{
    echo "Setup Pre-built Vortex Toolchain"
    echo "Usage: $0 [[--riscv] [--llvm-vortex] [--llvm-pocl] [--pocl] [--verilator] [--sv2v] [-yosys] [--all] [-h|--help]]"
}

while [ "$1" != "" ]; do
    case $1 in
        --pocl ) pocl
                ;;
        --verilator ) verilator
                ;;
        --riscv ) riscv
                ;;
        --riscv64 ) riscv64
                ;;
        --llvm-vortex ) llvm-vortex
                ;;
        --llvm-pocl ) llvm-pocl
                ;;
        --sv2v ) sv2v
                ;;
        --yosys ) yosys
                ;;
        --all ) riscv
                riscv64
                llvm-vortex
                llvm-pocl
                pocl
                verilator
                sv2v
                yosys
                ;;
        -h | --help ) show_usage
                exit
                ;;
        * ) show_usage
                exit 1
    esac
    shift
done

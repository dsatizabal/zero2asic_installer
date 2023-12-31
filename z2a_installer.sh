GREEN='\033[0;32m'
NC='\033[0m' # No Color
DIR="zerotoasic" # Set as desired
USER_HOME=$(eval echo ~$SUDO_USER)

### Go to users home folder
cd $USER_HOME

### Create a dir for all installed components
mkdir -p "$USER_HOME/$DIR"

# ==========================================================
# Basics components
echo "${GREEN}Basics components setup${NC}\n\n"

## Git
if ! command -v git &> /dev/null
then
	echo "Installing Git..."
	apt-get install --assume-yes git
fi

## Python
echo "Installing python..."
apt install --assume-yes python3-pip

## Check local/bin in PATH
if echo $PATH | grep '/.local';
then
	echo "${GREEN}PATH OK!${NC}"
else
	export PATH="$HOME/.local/bin:$PATH"
fi

# ==========================================================
# VLSI Tools
echo "${GREEN}VLSI tools setup${NC}\n\n"

### Go to installation dir
cd "$USER_HOME/$DIR" || exit 1

## Install Magic
echo "Installing Magic..."
apt-get --assume-yes install tcsh csh tcl-dev tk-dev libcairo2-dev

git clone git://opencircuitdesign.com/magic

cd magic || exit 1

git checkout 8.3.413

./configure

make

make install

### Back to installation dir
cd ..

## Install Docker
echo "Installing Docker..."

apt install --assume-yes docker.io

# Add your user to docker group so sudo is not required to run docker, YOU NEED to reboot your system!!!!
sudo groupadd docker
sudo usermod -aG docker $USER

## Caravel
### Create a directory for Caravel
mkdir "$USER_HOME/$DIR/caravel"
cd $USER_HOME/$DIR/caravel || exit 1

git clone https://github.com/efabless/caravel_user_project.git

export PDK_ROOT=${pwd}/pdk
export OPENLANE_ROOT=${pwd}/openlane

cd caravel_user_project || exit 1

git checkout b8efc55a816c11c27d0c363014c5213573b325c2

make setup

rm -rf caravel # wrong version
git clone https://github.com/efabless/caravel-lite caravel
cd caravel
git checkout f7a4b5655bf857f157491e55202ac7619dec1831

### Back to installation dir
cd $USER_HOME/$DIR || exit 1

## Local variables
echo "# Variables for Zero2ASIC components" >> $USER_HOME/.bashrc

echo "install_dir=~/$DIR/caravel" >> $USER_HOME/.bashrc
echo "caravel_dir_name=caravel_user_project" >> $USER_HOME/.bashrc

echo 'export PDK_ROOT=$install_dir/pdk' >> $USER_HOME/.bashrc
echo 'export OPENLANE_ROOT=$install_dir/openlane' >> $USER_HOME/.bashrc
echo 'export PDK=sky130A' >> $USER_HOME/.bashrc
echo 'export MGMT_AREA_ROOT=$install_dir/$caravel_dir_name/mgmt_core_wrapper' >> $USER_HOME/.bashrc
echo 'export DESIGNS=$install_dir/$caravel_dir_name' >> $USER_HOME/.bashrc
echo 'export TARGET_PATH=$DESIGNS' >> $USER_HOME/.bashrc
echo 'export CARAVEL_ROOT=$DESIGNS/caravel' >> $USER_HOME/.bashrc
echo 'export MCW_ROOT=$DESIGNS/mgmt_core_wrapper' >> $USER_HOME/.bashrc
echo 'export CORE_VERILOG_PATH=$MCW_ROOT/verilog' >> $USER_HOME/.bashrc

## Install NgSpice
echo "Installing NG Spice..."
apt install --assume-yes ngspice

# ==========================================================
# Install Digital Design Tools

echo "${GREEN}Digital Design tools setup${NC}\n\n"

## Install OSS CAD
echo "Installing OSS CAD..."

curl -L -o $USER_HOME/Downloads/osscadsuite.tgz https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2023-09-28/oss-cad-suite-linux-x64-20230928.tgz

cd $USER_HOME/$DIR/caravel || exit 1

tar -xzf $USER_HOME/Downloads/osscadsuite.tgz

echo 'export PATH=$PATH:$install_dir/oss-cad-suite/bin' >> $USER_HOME/.bashrc

## Install RISCV
echo "Installing RISCV Toolchain..."
curl -o $USER_HOME/Downloads/riscv.tar.gz https://static.dev.sifive.com/dev-tools/freedom-tools/v2020.12/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14.tar.gz

cd $USER_HOME/$DIR/caravel || exit 1
mkdir -p riscv64
cd riscv64 || exit 1

tar -xzf $USER_HOME/Downloads/riscv.tar.gz

### Add PATH exports for RISCV
echo "export GCC_PATH=$USER_HOME/$DIR/caravel/riscv64/bin/" >> $USER_HOME/.bashrc
echo 'export PATH=$PATH:$GCC_PATH' >> $USER_HOME/.bashrc
echo "export GCC_PREFIX=riscv64-unknown-elf" >> $USER_HOME/.bashrc


## Install OpenLane
echo "Installing OpenLane summary tool..."

cd $USER_HOME/$DIR/caravel

git clone https://github.com/mattvenn/openlane_summary

cd openlane_summary || exit 1

git checkout mpw9

echo 'export PATH=$PATH:$install_dir/openlane_summary/' >> $USER_HOME/.bashrc

# ==========================================================
# Removing downloaded files
echo "Almost done, lets free some space"

rm $USER_HOME/Downloads/osscadsuite.tgz
rm $USER_HOME/Downloads/riscv.tar.gz

echo "${GREEN}Installation complete!, do not forget reboot your system, install KLayout and test your installation${NC}\n\n"

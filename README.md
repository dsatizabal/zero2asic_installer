# zero2asic_installer
**Upgraded for mpw9 on Oct 14, 2023.**

Download the z2a_installer.sh file, you may need to set execution permissions by running:

```
sudo chmod +x Downloads/z2a_installer.sh
```

Then just run:

```
sudo Downloads/z2a_installer.sh
```

and it must install all components except KLayout as it is indicated to cause issues if not installed properly for your Ubuntu version.

After installation is finished **YOU MUST** reboot your system so the user configuration for Docker takes effect, then perform the tests as indicated in the Zero2Asic course.

BE CAREFUL: run the script only once, if it fails, you'll likely have to modify the .bashrc file as some exports are added to it.

The script was tested in Ububtu 20 and Linux Mint Cinnamon

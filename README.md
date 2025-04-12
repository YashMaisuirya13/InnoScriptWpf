# InnoScriptWpf
testApplication Installer Script
This repository contains the Inno Setup script used to create a Windows installer for the testApplication WPF project.

🚀 Overview
After completing the development of my WPF application, I needed a clean, user-friendly installer. Initially, I tried using Visual Studio’s Setup Wizard but quickly encountered its limitations. To overcome these, I switched to Inno Setup, which gave me full control over the installer process.

This script includes:
Custom desktop and Start Menu shortcuts
    Option to auto-launch the application after installation
    Support for creating registry keys for trial management
    Custom branding for the installer with app icon and name
    Version checks and clean uninstall support
    
🛠 Features
    Desktop and Start Menu Shortcuts: Create shortcuts during installation based on user preference.
    Automatic Application Launch: Option to launch the application after installation.
    Custom Branding: Use a custom icon for the installer.
    Terms & Conditions and License Agreement: Display and accept legal agreements during installation.
    Registry Management: Ability to handle trial licenses and store registry keys.

🔧 Requirements
    Inno Setup: Download and install from Inno Setup official site.
    Visual Studio (optional): For editing and building the installer script.
📝 How to Use
    Clone this repository to your local machine.
    Open testApplication.iss in Inno Setup.
    Customize the paths to your application files (e.g., testApplication.exe, SQLite.Interop.dll, etc.).
    Build the installer by clicking Compile in Inno Setup.
    Test the installer on a clean machine or VM to ensure everything works correctly.
📁 Files
    testApplication.iss: The main Inno Setup script file.
    Images/: Folder containing any necessary images used in the installer.
💡 Pro Tips
    Use Inno Script Studio or ISTool for a more visual editing experience.
    Use the {app} macro to reference the installation directory.
    Always test your installer in a clean environment (e.g., a VM) before distribution.

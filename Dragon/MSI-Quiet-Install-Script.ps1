Start-Process C:\Windows\System32\msiexec.exe -ArgumentList '/qn /i Standalone.msi INSTALLDIR="C:\Program Files (x86)\Nuance\Dragon Medical One" AUTHENTICATION="none" SERVERURL="https://sas.nuancehdp.com/basic" ORGANIZATIONTOKEN="ED8B27ED-22B3-4CF2-B158-370C3107851D" SUPPORTEDLANGUAGES="en-US" WPFSUPPORT=Yes SUPPORTEDTOPICS="GeneralMedicine|ClinicalAdministration|Cardiology|Emergency|InternalMedicine|MentalHealth|Neurology|Orthopaedics|ObstetricsAndGynecology|Oncology|Pathology|Pediatrics|Surgery"' -Wait

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Dragon Medical One.lnk")
$Shortcut.TargetPath = "C:\Program Files (x86)\Nuance\Dragon Medical One\SoD.exe"
$Shortcut.Save()

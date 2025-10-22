
# Backup Platform – Deployment Sheet

## Scope
Build JeOS appliance ISO/OVA, Windows Agent MSI, Linux Agent DEB/RPM. Deploy to test.

## Artifacts
- JeOS: `backup-jeos.ova`, `backup-jeos.iso`
- Windows Agent: `agent.msi`, `setup.exe`
- Linux Agent: `backup-agent_{ver}.deb` and `.rpm`

## Prereqs
- Packer, Ansible, genisoimage/xorriso
- WiX Toolset + signtool on Windows build VM
- fpm (gem), rpmbuild for Linux packages
- Code-signing cert for MSI

## Build

### JeOS
1. Edit `packer/jeos.pkr.hcl` checksum.
2. `packer build packer/jeos.pkr.hcl`
3. Outputs in `out/`.

### Windows Agent
1. Place compiled `AgentSvc.exe` in `windows/agent/`.
2. Build MSI:
   ```
   candle.exe Product.wxs
   light.exe Product.wixobj -o agent.msi
   signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 /a agent.msi
   ```
3. Bootstrapper:
   ```
   candle.exe Bundle.wxs
   light.exe Bundle.wixobj -o setup.exe
   signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 /a setup.exe
   ```

### Linux Agent
1. Put ELF at `linux/agent/bin/linux-x64/backup-agent`.
2. `bash linux/agent/build.sh`

## Deploy

### Appliance
- Import OVA, set IP, start Manager, open https://IP:5080/
- Verify `/metrics` and telemetry

### Windows Agent
- `msiexec /i agent.msi MANAGER_URL=https://mgr:5080 CHANNEL=stable /qn`
- Check service and logs

### Linux Agent
- `dpkg -i *.deb` or `rpm -Uvh *.rpm`
- `systemctl enable --now backup-agent`

## Rollback
- Windows: reinstall previous MSI or `agentctl rollback`
- Linux: downgrade via package manager

## Notes
- Build time: 2025-10-22 07:27:51 UTC

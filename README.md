# Anleitung zur Konfiguration der Sandbox (sandbox.wsb)

Die folgende Anleitung beschreibt die Konfigurationsdatei "sandbox.wsb", welche fuer die Einrichtung und den Betrieb einer Windows Sandbox genutzt wird. Diese Datei enthaelt verschiedene Einstellungen, die den Betrieb und die Umgebung der Sandbox steuern. Im Folgenden werden die einzelnen Bestandteile dieser Konfigurationsdatei detailliert erklaert.

## Grundstruktur der Konfigurationsdatei

Die Konfigurationsdatei ist im XML-Format und beginnt und endet mit dem `<Configuration>` Tag. Innerhalb dieses Tags befinden sich verschiedene weitere Tags, die spezifische Einstellungen definieren.

## 1. Grafikkartenvirtualisierung (vGPU)

```xml
<vGPU>Enable</vGPU>
```

Diese Einstellung aktiviert die Nutzung einer virtuellen GPU (vGPU) innerhalb der Sandbox, was die Leistung insbesondere fuer grafische Anwendungen verbessern kann, wenn auf dem Host-PC vorhanden.

## 2. Netzwerk

```xml
<Networking>Enable</Networking>
```

Diese Option ermoeglicht den Netzwerkzugriff innerhalb der Sandbox. Dies ist erforderlich, um z.B. auf das Internet oder andere Netzwerkressourcen zuzugreifen.

## 3. Mapped Folders (Zugeordnete Ordner)

```xml
<MappedFolders>
  <MappedFolder>
    <HostFolder>C:\temp\sandbox</HostFolder>
    <SandboxFolder>C:\sandbox</SandboxFolder>
  </MappedFolder>
</MappedFolders>
```

Dieser Abschnitt definiert zugeordnete Ordner zwischen dem Host-Betriebssystem und der Sandbox:
- **HostFolder**: Der Ordner auf dem Host-System, der für die Sandbox verfügbar gemacht wird.
- **SandboxFolder**: Der entsprechende Ordner innerhalb der Sandbox.

In diesem Fall wird der Ordner `C:\temp\sandbox` auf dem Host-System dem Ordner `C:\sandbox` in der Sandbox zugeordnet.

## 4. Logon Command (Anmeldebefehl)

```xml
<LogonCommand>
  <Command>powershell.exe -ExecutionPolicy Unrestricted -File "C:\sandbox\install-and-run-openvpn-Copy.ps1"</Command>
</LogonCommand>
```

Diese Einstellung führt beim Start der Sandbox einen bestimmten Befehl aus. Hier wird ein PowerShell-Skript (`install-and-run-openvpn-Copy.ps1`) mit uneingeschränkter Ausführungsrichtlinie ausgeführt.

## 5. Audio Input (Audioeingabe)

```xml
<AudioInput>Enable</AudioInput>
```

Diese Option aktiviert die Audioeingabe innerhalb der Sandbox, sodass Mikrofoneingaben in der Sandbox genutzt werden können.

## 6. Video Input (Videoeingabe)

```xml
<VideoInput>Enable</VideoInput>
```

Diese Einstellung ermöglicht die Nutzung der Videoeingabe (z.B. Kamera) innerhalb der Sandbox.

## 7. Clipboard Redirection (Zwischenablage-Umleitung)

```xml
<ClipboardRedirection>Enable</ClipboardRedirection>
```

Diese Option erlaubt die Nutzung der Zwischenablage zwischen dem Host und der Sandbox, sodass Inhalte kopiert und eingefügt werden können.

## 8. Arbeitsspeicher (Memory)

```xml
<MemoryInMB>4096</MemoryInMB>
```

Hier wird die Menge des zugewiesenen Arbeitsspeichers fuer die Sandbox definiert. In diesem Fall sind es 4096 MB (4 GB).

## Zusammenfassung

Die Datei `sandbox.wsb` konfiguriert eine Windows Sandbox mit folgenden Eigenschaften:
- Aktivierte virtuelle GPU und Netzwerkzugriff.
- Zuordnung des Host-Ordners `C:\temp\sandbox` zum Sandbox-Ordner `C:\sandbox`.
- Ausfuehrung eines PowerShell-Skripts beim Start.
- Aktivierte Audio- und Videoeingabe sowie Zwischenablage-Umleitung.
- Zuweisung von 4 GB Arbeitsspeicher.

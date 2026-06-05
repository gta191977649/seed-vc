$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$venvPath = Join-Path $projectRoot ".venv-xpu"
$pythonExe = Join-Path $venvPath "Scripts\python.exe"

if (-not (Test-Path $venvPath)) {
    py -3.10 -m venv $venvPath
}

& $pythonExe -m pip install --upgrade pip setuptools wheel

# Install the official Intel XPU PyTorch wheels first so later packages reuse them.
& $pythonExe -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/xpu

# Install project dependencies except the source-built webrtcvad package.
& $pythonExe -m pip install `
    scipy==1.13.1 `
    librosa==0.10.2 `
    "huggingface-hub>=0.28.1" `
    munch==4.0.0 `
    einops==0.8.0 `
    descript-audio-codec==1.0.0 `
    gradio==5.23.0 `
    pydub==0.25.1 `
    jiwer==3.0.3 `
    transformers==4.46.3 `
    FreeSimpleGUI==5.1.1 `
    soundfile==0.12.1 `
    sounddevice==0.5.0 `
    modelscope==1.18.1 `
    funasr==1.1.5 `
    hydra-core==1.3.2 `
    pyyaml `
    python-dotenv `
    accelerate `
    typing==3.7.4.3 `
    webrtcvad-wheels==2.0.14

# Resemblyzer depends on webrtcvad, but the source package fails to build on Windows.
# Install the package itself without re-resolving dependencies after webrtcvad-wheels is present.
& $pythonExe -m pip install resemblyzer==0.1.4 --no-deps

Write-Host ""
Write-Host "XPU environment is ready at $venvPath"
Write-Host "Activate it with:"
Write-Host "  .\.venv-xpu\Scripts\Activate.ps1"

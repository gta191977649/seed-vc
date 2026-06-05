import torch


def get_best_device(prefer_index: int | None = None) -> torch.device:
    if torch.cuda.is_available():
        if prefer_index is not None:
            return torch.device(f"cuda:{prefer_index}")
        return torch.device("cuda")
    if hasattr(torch, "xpu") and torch.xpu.is_available():
        if prefer_index is not None:
            return torch.device(f"xpu:{prefer_index}")
        return torch.device("xpu")
    if torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


def get_default_dtype(device: torch.device, prefer_half: bool = True) -> torch.dtype:
    if not prefer_half:
        return torch.float32
    if device.type in {"cuda", "xpu"}:
        return torch.float16
    return torch.float32


def is_half_precision_enabled(device: torch.device, prefer_half: bool = True) -> bool:
    return prefer_half and device.type in {"cuda", "xpu"}

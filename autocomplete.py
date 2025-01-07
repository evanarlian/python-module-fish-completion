from pathlib import Path


def module_autocomplete(module_path: str) -> set[str]:
    try:
        if module_path.startswith("."):
            # python does not support relative module name using python -m
            return set()
        if module_path.endswith("."):
            # "app.core." can be autocompleted to "app.core.engine"
            cwd = Path(module_path.replace(".", "/"))
            tail = None
        else:
            # "app.core" can be autocompleted to "app.coreboot"
            if "." in module_path:
                module_path, tail = module_path.rsplit(".", maxsplit=1)
                module_path = module_path.replace(".", "/")
            else:
                module_path, tail = "", module_path
            cwd = Path(module_path)

        # generate valid path that might be able to be run using python -m
        # some python -m behavior:
        # * does not support relative module invocation, e.g. python -m .meme
        # * if the same filename and folder found, this is the precedence of execution
        #   * package, e.g. app/check/ (must have __init__.py and __main__.py)
        #   * file module, e.g. app/check.py
        #   * folder module, e.g. app/check/ (must have only __main__.py)
        # * note that __init__.py is only needed to mark a folder as package, but python will still run the __main__.py
        valid_paths: set[str] = set()
        for path in Path(cwd).iterdir():
            if path.name.startswith("."):
                continue
            if path.is_dir() and path.name == "__pycache__":
                continue
            if path.is_file() and path.name in {"__main__.py", "__init__.py"}:
                continue
            if not (path.is_dir() or path.suffix == ".py"):
                continue
            if tail is not None and not path.name.startswith(tail):
                continue
            if path.is_dir():
                cleaned = str(path).replace("/", ".") + "."
            else:
                assert path.suffix == ".py"
                cleaned = str(path).replace("/", ".")[:-3]
            valid_paths.add(cleaned)
        return valid_paths
    except Exception:
        return set()


def main():
    paths = module_autocomplete('""$target_path""')
    for path in sorted(paths):
        print(path)


if __name__ == "__main__":
    main()

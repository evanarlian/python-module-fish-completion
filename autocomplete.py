from pathlib import Path


def module_autocomplete(module_path: str) -> list[str]:
    if module_path.startswith("."):
        # python does not support relative module name using python -m
        return []
    if module_path.endswith("."):
        # "app.core." can be autocompleted to "app.core.engine"
        cwd = Path(module_path.replace(".", "/"))
        tail = None
    else:
        # "app.core" can be autocompleted to "app.coreboot"
        module_path, tail = f".{module_path}".rsplit(".", maxsplit=1)
        cwd = Path(module_path)

    # generate valid path that might be able to be run using python -m
    # some python -m behavior:
    # * does not support relative module invocation
    # * if the same filename and folder found, like app/check.py and app/check/, folder will win TODO sus!!!
    # * folder (ex: app/check/) can be run as module if it contains main (ex: app/check/__main__.py)
    valid_paths: set[str] = set()
    for path in Path(cwd).iterdir():
        if path.name.startswith("."):
            continue
        if path.name == "__pycache__":
            continue
        if not (path.is_dir() or path.suffix == ".py"):
            continue
        if tail is not None and not path.name.endswith(tail):
            continue
        if path.is_dir():
            cleaned = str(path).replace("/", ".").replace(" ", "\\ ")
        else:
            assert path.suffix == ".py"
            cleaned = str(path).replace("/", ".").replace(" ", "\\ ")[:-3]
        valid_paths.add(cleaned)

    return sorted(valid_paths)


# modules = get_all_modules(".")
# print(modules, sep="\n")


paths = module_autocomplete("testapp.")
for path in paths:
    print(path)

# fusk fish! i am designing this shit myself using python and python3!!
# that way, i can completely gain control of this project
# NOTES:
# * app/check/__main__.py will win vs app/check.py if we execute python -m app.check, and the weird thing is if app/check/ does not have __main__.py, the folder will still win!
# * python can handle spaces in the module name during python -m app.lol\ lol
# * i think it will be great if i make a simple unit test on these quirks
# *

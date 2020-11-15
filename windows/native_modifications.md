## 1. Changes made in `runner/main.cpp`

#### In method `wWinMain()`

```cpp
// Get & Set window WorkArea size
RECT workArea;
SystemParametersInfoA(SPI_GETWORKAREA, 0, &workArea, 0);

// Aligning window at center
Win32Window::Point origin((workArea.right / 2) - (1040 / 2), (workArea.bottom / 2) - (585 / 2));
// Adjusting to right size
Win32Window::Size size(1040, 585);
```

## 2. Changes made in `runner/win32_window.cpp`

#### In typedef `HWND window` in method `Win32Window::CreateAndShow()`

Replaced `WS_OVERLAPPEDWINDOW` with `WS_POPUP`.

#### Added just after the above replacement

```cpp
// Removing all window styles
SetWindowLong(window, GWL_EXSTYLE, WS_EX_TOOLWINDOW | WS_EX_LAYERED | WS_VISIBLE);
```

## 3. Changes made in `CMakeLists.txt`

#### Added at the end

```cmake
# Copy the scripts folder to output directory
install(DIRECTORY "scripts" DESTINATION "${CMAKE_INSTALL_PREFIX}" COMPONENT Runtime)
```
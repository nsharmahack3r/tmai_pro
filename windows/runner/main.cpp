#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include <gdiplus.h>
#pragma comment(lib, "Gdiplus.lib")

using namespace Gdiplus;

#include "flutter_window.h"
#include "utils.h"
#include <memory>

// ---------------- GDI+ ----------------
ULONG_PTR gdiplusToken;

void InitGDIPlus() {
  GdiplusStartupInput input;
  GdiplusStartup(&gdiplusToken, &input, nullptr);
}

void ShutdownGDIPlus() {
  GdiplusShutdown(gdiplusToken);
}

// ---------------- Splash globals ----------------
HWND gSplashHwnd = nullptr;
std::unique_ptr<Image> gSplashImage;

// ---------------- Helpers ----------------
std::wstring GetExeDir() {
  wchar_t path[MAX_PATH];
  GetModuleFileName(nullptr, path, MAX_PATH);
  std::wstring p(path);
  return p.substr(0, p.find_last_of(L"\\/"));
}

// ---------------- Splash WndProc ----------------
LRESULT CALLBACK SplashWndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
  switch (msg) {
    case WM_PAINT: {
      PAINTSTRUCT ps;
      HDC hdc = BeginPaint(hwnd, &ps);

      if (gSplashImage && gSplashImage->GetLastStatus() == Ok) {
        Graphics g(hdc);
        g.DrawImage(
          gSplashImage.get(),
          0,
          0,
          (INT)gSplashImage->GetWidth(),
          (INT)gSplashImage->GetHeight()
        );
      }

      EndPaint(hwnd, &ps);
      return 0;
    }

    case WM_DESTROY:
      return 0;
  }
  return DefWindowProc(hwnd, msg, wParam, lParam);
}

// ---------------- Splash creation ----------------
HWND ShowPngSplashScreen() {
  const int width = 800;
  const int height = 600;

  WNDCLASS wc{};
  wc.lpfnWndProc = SplashWndProc;
  wc.hInstance = GetModuleHandle(nullptr);
  wc.lpszClassName = L"FlutterSplashWindow";
  RegisterClass(&wc);

  HWND hwnd = CreateWindowEx(
      WS_EX_LAYERED,
      wc.lpszClassName,
      L"",
      WS_POPUP,
      (GetSystemMetrics(SM_CXSCREEN) - width) / 2,
      (GetSystemMetrics(SM_CYSCREEN) - height) / 2,
      width,
      height,
      nullptr,
      nullptr,
      wc.hInstance,
      nullptr);

  SetLayeredWindowAttributes(hwnd, 0, 255, LWA_ALPHA);

  // ---- ABSOLUTE PATH (CRITICAL) ----
  std::wstring imgPath = GetExeDir() + L"\\resources\\splash.png";
  gSplashImage = std::make_unique<Image>(imgPath.c_str());

  if (gSplashImage->GetLastStatus() != Ok) {
    MessageBox(nullptr, imgPath.c_str(), L"Failed to load splash.png", MB_ICONERROR);
  }

  ShowWindow(hwnd, SW_SHOW);
  UpdateWindow(hwnd);

  gSplashHwnd = hwnd;
  return hwnd;
}

// ---------------- Entry ----------------
int APIENTRY wWinMain(_In_ HINSTANCE instance,
                      _In_opt_ HINSTANCE prev,
                      _In_ wchar_t* command_line,
                      _In_ int show_command) {

  if (!AttachConsole(ATTACH_PARENT_PROCESS) && IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
  SetProcessDPIAware();

  // ---- SPLASH ----
  InitGDIPlus();
  HWND splash = ShowPngSplashScreen();

  // ---- FLUTTER ----
  flutter::DartProject project(L"data");
  project.set_dart_entrypoint_arguments(GetCommandLineArguments());

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);

  if (!window.Create(L"Tmai Pro", origin, size)) {
    DestroyWindow(splash);
    ShutdownGDIPlus();
    return EXIT_FAILURE;
  }

  window.SetQuitOnClose(true);

  // Keep splash visible
  Sleep(5000);

  DestroyWindow(splash);
  ShutdownGDIPlus();

  MSG msg;
  while (GetMessage(&msg, nullptr, 0, 0)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }

  CoUninitialize();
  return EXIT_SUCCESS;
}

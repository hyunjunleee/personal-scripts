# Linux & WSL Scripts (2026)

리눅스 데스크톱(Wayland/X11)과 WSL(Windows Subsystem for Linux) 환경을 다루면서 발생했던 파편화 및 연동 문제들을 직접 해결하기 위해 제작한 Bash CLI 유틸리티입니다.

## 유틸리티 목록

| 명령어 | 기능 요약 | 주요 기술 & 해결한 문제 |
| :--- | :--- | :--- |
| **`dl`** | 윈도우 다운로드 폴더 ➔ WSL 연동 및 파일 추출 | 동적 윈도우 환경변수 파싱, 크로스 OS 파일 시스템 병목 해결 |
| **`vmnt`** | WSL VHDX & EXT4 크로스 마운트 매니저 | PowerShell Base64 인코딩을 통한 Linux ➔ Windows UAC 권한 우회 |
| **`xclip_img`** | Wayland ➔ X11 이미지 클립보드 Forwarder | X11 클립보드 소유권 지연 문제(Race Condition) 폴링으로 해결 |

---

## 상세 가이드 및 Usage

### 1. `dl` (WSL Download Fetcher)
WSL 터미널에서 윈도우의 다운로드 폴더에 안전하게 접근하여 최신 파일을 복사/이동/정리합니다. 윈도우 환경 변수를 동적으로 캐싱하여 다양한 환경에서 완벽하게 작동합니다.

* **Prerequisites:** WSL 환경 (Windows Interop 활성화)
* **Usage:** `dl [숫자] [옵션]`

** Options**
| 옵션 | 설명 |
| :--- | :--- |
| `-m`, `--move` | 복사가 아닌 이동(`mv`) 수행 |
| `-g`, `--global` | 기본 폴더(`.`) 대신 WSL 다운로드 폴더(`~/downloads`)로 가져오기 |
| `-d`, `--dir` | 파일뿐만 아니라 디렉토리도 포함하여 가져오기 |
| `-l`, `--list` | 윈도우 다운로드 폴더의 최신 항목 출력 (기본 5개) |
| `-f`, `--file` | 특정 이름의 파일이나 디렉토리를 정확히 지정해서 가져오기 |
| `--clean` | 다운로드 폴더 비우기 (안전을 위해 파일마다 삭제 여부 `rm -i` 확인) |

** Examples**
```bash
dl 3 -m           # 최신 다운로드 항목 3개를 현재 폴더로 이동(mv)
dl -l             # 다운로드 폴더의 최신 5개 항목 리스트업
dl -f report.pdf  # 'report.pdf' 파일만 현재 폴더로 복사
dl --clean        # 쌓인 다운로드 폴더 정리 시작
```


### 2. `vmnt` (WSL VHD & EXT4 Mount Manager)
Windows의 VHDX 파일이나 원시 이미지(ext4, img)를 WSL 환경으로 손쉽게 제어하고, 현재 작업 폴더에 심볼릭 링크까지 자동으로 연동해 주는 마운트 매니저입니다.
* **Prerequisites:** WSL 2 (Windows 11+), `iconv`, `base64`, `findmnt`
* **Usage:** `vmnt [flags] <name>`

** Options**
| 옵션 | 설명 |
| :--- | :--- |
| `-m`, `--mount` | **[기본값]** VHDX/image 마운트 및 현재 폴더에 링크 생성 |
| `-i`, `--image` | 대상이 VHDX가 아닌 원시 이미지(`ext4`, `img`) 파일일 때 사용 |
| `-u`, `--unmount` | 마운트 해제 및 현재 폴더의 링크 삭제 |
| `-l`, `--list` | 현재 `/mnt/wsl` 아래의 마운트 목록 확인 |
| `-r`, `--readonly` | `image` 모드에서 읽기 전용으로 마운트 |
| `-d`, `--dir <path>`, `--base-dir <path>` | 파일을 찾을 기본 디렉터리 지정 |
| `--no-link` | 현재 폴더에 심볼릭 링크를 만들거나 삭제하지 않음 |

** Default:** * 아무 경로를 지정하지 않을 경우 기본 검색 위치는 D 드라이브입니다.
> * VHD 모드의 읽기 전용 마운트는 지원하지 않습니다. 안전한 읽기 전용 마운트가 필요하다면 image 모드(`-i -r`)를 사용하세요.

** Examples**
```bash
vmnt snu                      # D:\snu.vhdx 를 VHD 모드로 마운트
vmnt -i snu                   # /mnt/d/snu.ext4 (또는 img) 를 image 모드로 마운트
vmnt -d E snu                 # E:\snu.vhdx 를 VHD 모드로 마운트
vmnt -d 'E:\WSL Images' snu   # 경로에 띄어쓰기가 있는 경우 따옴표 사용
vmnt -i -r -d /mnt/e/img snu  # 특정 경로의 원시 이미지를 읽기 전용으로 마운트
vmnt data.img                 # 확장자를 직접 지정하여 마운트
```

### 3. `xclip_img` (Wayland to X11 Clipboard Forwarder)
Wayland 환경에서 복사한 이미지(webp, bmp 등)가 구형 Xwayland(X11) 앱에 정상적으로 붙여넣기 되지 않는 디스플레이 서버 간의 파편화 버그를 해결하는 백그라운드 유틸리티입니다.

* **Prerequisites:** `wl-clipboard`, `xclip`, `imagemagick`
* **Usage:** 별도의 인자(옵션) 없이 명령어만 실행합니다. `xclip_img`

** Core Features & Logic**

| 기능 | 설명 |
| :--- | :--- |
| **자동 포맷 정규화** | 클립보드의 MIME 타입을 감지하여 다양한 포맷(`bmp`, `jpeg`, `gif`, `webp`)을 호환성이 가장 높은 `PNG`로 자동 변환합니다. |
| **Race Condition 방어** | X11 `xclip` 특성상 백그라운드 전환 시 발생하는 소유권 획득 지연 문제를 해결하기 위해, 최대 1초(0.1초 x 10회)간 `TARGETS`를 폴링(Polling)하여 완벽한 주입을 보장합니다. |
| **메모리 및 프로세스 관리** | 충돌을 막기 위해 기존의 고아 `xclip` 프로세스를 `pkill`로 우선 정리하며, `trap` 구문을 통해 스크립트 강제 종료 시에도 임시 생성된 파일(`mktemp`)을 깔끔하게 삭제합니다. |

** Examples & Tips**
```bash
# 터미널에서 수동 실행 (Wayland 이미지 복사 후 작동)
xclip_img

# 설정 > Keyboard Shortcuts 에서 아래 명령어를 사용자 지정 단축키(예: Ctrl+Shift+C)로 매핑 가능
bash -c "~/.local/bin/xclip_img"
```

> **상태 코드 (Exit Status):**
> 문제가 발생했을 때 스크립트의 종료 코드로 원인을 파악할 수 있습니다.
> * `1` : 클립보드에 이미지 데이터가 없음
> * `2` : PNG 포맷 변환 실패 (ImageMagick 에러 등)
> * `3` : Wayland 클립보드에는 등록되었으나 X11 주입 실패
> * `4` : 시스템 에러. 변환 이미지를 Wayland 클립보드에도 올리지 못함

---

##  Installation

```bash
# 1. 의존성 패키지 설치 (Ubuntu/Debian 기준)
sudo apt update && sudo apt install -y wl-clipboard xclip imagemagick

# 2. 실행 권한 부여 및 심볼릭 링크(slink) 생성
chmod +x dl vmnt xclip_img
mkdir -p ~/.local/bin 

ln -s "$PWD/dl" ~/.local/bin/dl
ln -s "$PWD/vmnt" ~/.local/bin/vmnt
ln -s "$PWD/xclip_img" ~/.local/bin/xclip_img
```


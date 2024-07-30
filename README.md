# MoCoDot

# 1. 소개 및 기간

### 1.1 소개

- 한글/영어 문자를 모스부호로 변환시켜주는 서비스

### 1.2 개발 기간

- 2024.03.10 - 2024.04.08 (4주)

## 2. 목표와 기능

### 2.1 목표

- 한글과 영어를 모스코드로 변환해보기

### 2.2 기능

- 한/영 모스코드 변환
- 모스코드 라이트/진동/소리 작동
- 모스코드 표 조회

## 3. 개발 환경

### 3.1 개발 환경 및 배포 URL

- 버전 정보
  - iOS 16.0 이상
- 라이브러리 및 프레임워크
  - `UIKit`
  - `Combine`
  - `Snapkit`
  - `Fastlane`


## 4. UI

### 4.1 페이지별 UI

<table>
    <tbody>
        <tr>
            <td>한글 모스코드 변환</td>
            <td>영어 모스코드 변환</td>
        </tr>
        <tr>
            <td>
		<img src="https://velog.velcdn.com/images/jakkujakku98/post/e00a92c6-8e22-4878-9757-3044410540bc/image.gif" width="100%">
            </td>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/5909b84b-7231-40e9-8a9d-683923b108fb/image.gif" width="100%">
            </td>
        </tr>
        <tr>
            <td>모스코드 재생</td>
            <td>모스코드 표 조회</td>
        </tr>
        <tr>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/381f5fab-8782-4ca1-90b1-d780708ee8d1/image.gif" width="100%">
            </td>
            <td>
                <img src="https://velog.velcdn.com/images/jakkujakku98/post/1f88ebd8-7c5e-4c5e-925f-38791374d681/image.gif" width="100%">
            </td>
        </tr>
  </tbody>
</table>

## 5. 에러와 에러 해결

- 한글을 모스부호로 변환하면서 겪은 문제

## 상황

영어와 달리 한글은 자음, 모음 한 개가 의미를 가지지 않는 특성이 있다.

한글을 모스부호로 변환하기 위해서는 자음, 모음 한 개를 각각 따로 변환 시켜야 하는 상황이 생겼다.

## 문제

“안”을 각각 “ㅇ”, “ㅏ”, “ㄴ” 으로 분리하여, 모스부호로 변환을 시켜야 한다.

## 1차 행동

1. “안” 과 같은 단어를 초성, 중성, 종성 으로 분리시켜야 했다.

```swift
func translateKoreanToUtf(at message: String) -> [Int] {
    var answer = [Int]()
    var index = 0
    
    for i in message.utf16 {
        index = Int(i)

        let cho = ((index - 0xAC00) / 28) / 21 // 초성
        answer.append(cho)

        let jung = ((index - 0xAC00) / 28) % 21 // 중성
        answer.append(jung)

        let jong = (index - 0xAC00) % 28 - 1 // 종성
        answer.append(jong)
    }

    return answer
}
```

1. 변환된 Int 배열을 For 문을 사용하여 한글 모스부호 리스트와 맞는 것을 찾아 나간다.

```swift
func checkKoreanSingleCharacter(input: String) -> String {
    let koreanText = input.split(separator: "").joined()
    var answer = ""

    for i in koreanText.enumerated() {
        let utfList = translateKoreanToUtf(at: i.element.description)
        let x = utfList[0] >= 0
        let y = utfList[1] >= 0
        let z = utfList[2] >= 0

        answer += x ? morseList[0][utfList[0]].morseCode : ""
        answer += y ? morseList[1][utfList[1]].morseCode : ""
        answer += z ? morseList[2][utfList[2]].morseCode : ""

        if i.offset < koreanText.count - 1 {
            answer += " "
        }
        else if i.element == "\\n" {
            answer += "\\n"
        }
        else {
            answer += ""
        }
    }
    return answer
}
```

1. 1,2 과정을 실행한 결과, 정상적으로 변환된 모스부호들이 나왔다.

------

## 2차 행동

“안”, “아” 와 같은 단어들은 정상적으로 출력이 되었다. 그러나 “ㅇ”, “ㅏ”, “ㄴ” 과 같은 하나의 자음 또는 모음만 입력했을 때는 실패 값을 내보내는 것이다.

1. `checkKoreanSingleCharacter` 메서드를 다시 살펴 보았다.

```swift
func checkKoreanSingleCharacter(input: String) -> String {
        let koreanText = input.split(separator: "").joined()
        var answer = ""

        for i in koreanText.enumerated() {
            let utfList = translateKoreanToUtf(at: i.element.description)
            let x = utfList[0] >= 0
            let y = utfList[1] >= 0
            let z = utfList[2] >= 0

            answer += x ? morseList[0][utfList[0]].morseCode : ""
            answer += y ? morseList[1][utfList[1]].morseCode : ""
            answer += z ? morseList[2][utfList[2]].morseCode : ""

            if i.offset < koreanText.count - 1 {
                answer += " "
            }
            else if i.element == "\\n" {
                answer += "\\n"
            }
            else {
                answer += ""
            }
        }

        return answer
    }
```

1. 살펴 본 결과, “ㅇ”, “ㅏ”, “ㄴ” 처럼 하나의 자음, 모음만 입력받으면 x, y, z 변수들이 한글 모스부호 리스트에서 값을 찾지 못하는 것을 확인하였다. 그래서 예외 케이스에 대응할 수 있는 코드를 만들었다.

```swift
if x == false, y == false, z == false {
		// zip 으로 x, y만 검사한 이유는 종성만 따로 쓸 수가 없기 때문이다.
    for d in zip(morseList[0], morseList[1]) {
        if d.0.alphabetName == i.element.description {
            answer += d.0.morseCode
        }
        else if d.1.alphabetName == i.element.description {
            answer += d.1.morseCode
        }
    }
}
```

## 결과

“안”, “ㅇ” 과 같은 입력들을 정상적으로 모스부호로 변환시켰다.

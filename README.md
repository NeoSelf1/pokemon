## 포켓몬 연락처 앱

# 📖 목차
- 프로젝트 소개
- 기술스택
- 주요기능
- Trouble Shooting

# 👨‍🏫 프로젝트 소개
포켓몬 API를 활용한 iOS 연락처 애플리케이션입니다. 
사용자는 연락처를 추가할 때 랜덤 포켓몬 이미지를 프로필 사진으로 설정할 수 있습니다. 
CoreData를 사용하여 로컬 데이터베이스에 연락처 정보를 저장하고 관리합니다.

# 📚️ 기술스택
- UIKit
- CoreData
- MVC Architecture

# ✔️ Network
URLSession + PokeAPI

# ✔️ Version Control
GitHub

# 주요기능
- 연락처 목록 표시 (이름순 정렬)
- 연락처 추가/수정
- 랜덤 포켓몬 이미지 프로필 설정=
- CoreData를 활용한 로컬 데이터 저장
- 포켓몬 API 연동
    
# Trouble Shooting
연락처 정렬 문제

문제: 연락처 목록이 이름순으로 정렬되지 않는 문제 발생
원인: TableView에서 정렬된 배열(sortedContacts) 대신 원본 배열(contacts) 사용하여서 정렬이 되지 않는 것이었습니다.

해결:
```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
      let contact = sortedContacts[indexPath.row] // contacts[indexPath.row]에서 수정
      cell.configure(with: contact)
      return cell
  }
```


# 기술적 의사결정
앱 전역에서 공통된 데이터에 접근해야하는 것이였기 때문에, 동시 업데이트 문제를 방지하고자 NetworkManager와 CoreDataManager에 싱글톤 패턴을 적용히얐습니다.

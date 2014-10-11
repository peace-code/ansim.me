# 안심이 ansim.me

안심이는 시민에게 안전 정보를 제공하는 플랫폼입니다.

2012 8월 공공데이터캠프에서 아이디어를 얻어 구현하였고, 그 이후에 4명의 관심자들이 종종 만나면서 시민이 안심할 수 있도록 하는 데이터를 좀 더 찾아 제공하려고 노력하고 있습니다.

## 개발 환경 구축하기

`ruby 2.1.2, rails 4.`


```
# 어쨌든 루비 개발 환경을 구축합니다.
rbenv install 2.1.2
gem install bundler

cd ansim.me
bundle install
rbenv rehash
rails s

# open http://localhost:3000
# rock & roll!

```

## 기여하기
우리의 안전을 중요하게 생각하는 분들의 진심어린 참여를 기다리고 있습니다. 현재는 개발자 중심으로 프로젝트를 끌어가고 있습니다만, 불편한 디자인이나 기능, 오작동 등은 [이슈](https://github.com/peace-code/ansim.me/issues)를 등록해주시거나 오타를 수정하시고, 코드를 커밋해주시면 @.@!

1. 일단 [포크](https://github.com/peace-code/ansim.me/fork)하세요!
2. 피처 브랜치를 만들어요. `git checkout -b my-new-feature`
3. 수정사항을 커밋하세요. `git commit -am 'Add some feature'`
4. 만든 피처 브랜치로 푸시하세요 `git push origin my-new-feature`
5. 땡겨달라고 요청(Pull Request)하세요 :D

## 이력

2012년 공공데이터캠프 참가

## 크레딧
팀 피스 코드(Team peace code)
권오현, 이정표, 김성준, 최명진, 홍영택


## 라이선스
[BEERWARE-LICENSE](https://raw.githubusercontent.com/peace-code/ansim.me/master/BEERWARE-LICENSE)

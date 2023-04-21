## Current release (in development)

## 0.5.1 [2023-04-21]

* Fix error introduced in 0.5.0 so now least one clock tick occurs when starting and ending at the same time [#41](https://github.com/kevin-j-m/clockwork-test/pull/41)

  *Robin Brandt*

## 0.5.0 [2023-04-20]

* Support timecop safe mode [#39](https://github.com/kevin-j-m/clockwork-test/pull/39)

  *Felix Dumit*

* Test against ruby 3.0, 3.1, 3.2

  *Kevin Murphy*

* Remove testing prior clockwork versions

  * *Kevin Murphy*

* Test against latest release version of clockwork at the time: 2.0.4

  * *Kevin Murphy*

* Test against latest ruby 2.5.x, 2.6.x, 2.7.x

  * *Kevin Murphy*

* Update rake

  * *Kevin Murphy*

## 0.4.0 [2020-04-23]

* Support clockwork callbacks [#34](https://github.com/kevin-j-m/clockwork-test/pull/34)

  *Rahul Agrawal*

## 0.3.0 [2018-06-19]

* Introduce release process documentation [#14](https://github.com/kevin-j-m/clockwork-test/pull/14)

  *Kevin Murphy*

* Test against master branch of clockwork [#18](https://github.com/kevin-j-m/clockwork-test/pull/18)

  *Kevin Murphy*

* Add activesupport as dev dependency [#19](https://github.com/kevin-j-m/clockwork-test/pull/19)

  *Kevin Murphy*

* Update ruby point versions in testing matrix [#22](https://github.com/kevin-j-m/clockwork-test/pull/22)

  *Kevin Murphy*

* Add clockwork 2.0.3, support `skip_first_run` option [#25](https://github.com/kevin-j-m/clockwork-test/pull/25)

  *[Oleksandr Rozumii](https://github.com/brain-geek)*

* Default `end_time` to current time if `start_time` is provided with no end time [#26](https://github.com/kevin-j-m/clockwork-test/pull/26)

  *[Oleksandr Rozumii](https://github.com/brain-geek)*

## 0.2.0

* Refactor custom matcher to remove repeated code [#8](https://github.com/kevin-j-m/clockwork-test/pull/8)

  *Kevin Murphy*

* Test against ruby 2.3 explicitly [#9](https://github.com/kevin-j-m/clockwork-test/pull/9)

  *Kevin Murphy*

* Avoid changing global time zone state [#10](https://github.com/kevin-j-m/clockwork-test/pull/10)

  *Adam Prescott*

* Add Appraisal to test various versions of clockwork [#13](https://github.com/kevin-j-m/clockwork-test/pull/13)

  *Kevin Murphy*

* Update run loop to support clockwork versions >= 2.01 [#13](https://github.com/kevin-j-m/clockwork-test/pull/13)

  *Kevin Murphy*

## 0.1.1

* Pass clock file configuration to Clockwork::Test::Manager [#7](https://github.com/kevin-j-m/clockwork-test/pull/7)

  *Kevin Murphy*

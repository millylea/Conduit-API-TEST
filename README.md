# ConduitKarate
This automation test is for [angular-realworld-example-app](https://github.com/gothinkster/angular-realworld-example-app)

To run this test, you must have [Karate set up] (https://github.com/karatelabs/karate?tab=readme-ov-file#quickstart)

## Funtional test
### Command lines:
- To run whole test:
  ```
  mvn test
  ```
- To run a certain feature or scenario, put a @debug tag before it:
  ```
  mvn test -Dkarate.options="--tags @debug"
  ```
- To run a whole test but skip a certain feature or scenario, put a @skipme tag before it:
  ```
  mvn test -Dkarate.options="--tags ~~@skipme"
  ```
### Reports
Reports are auto-generated in "target/cucumber-html-reports " folder
![Screenshot 2024-07-22 091935](https://github.com/user-attachments/assets/d2fa38e8-449c-47ed-b7fb-dbbdc2843758)

![Screenshot 2024-07-22 092011](https://github.com/user-attachments/assets/7697d8e9-a4f8-401f-aac3-dfaf0767fb71)

## Performance test:

command line:
```
mvn clean test-compile gatling:test
```
Report are auto-generated in "target/gatling"
![Screenshot 2024-07-22 092224](https://github.com/user-attachments/assets/ed6b6946-4539-481b-8763-20a9bcbc188a)


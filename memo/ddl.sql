/*항상 범위 주석을 사용한다.*/
CREATE TABLE TBL_MEMBER(
	ID NUMBER CONSTRAINT PK_MEMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(255) CONSTRAINT UK_MEMBER UNIQUE,
	MEMBER_PASSWORD VARCHAR2(255),
	MEMBER_AGE NUMBER(3) CONSTRAINT CHECK_AGE CHECK(MEMBER_AGE > 0)
);

CREATE TABLE TBL_ORDER(
	ID NUMBER CONSTRAINT PK_ORDER PRIMARY KEY,
	MEMBER_ID NUMBER,
	ORDER_DATE DATE DEFAULT CURRENT_TIMESTAMP,
	ORDER_COUNT NUMBER DEFAULT 1,
	CONSTRAINT FK_ORDER_MEMBER FOREIGN KEY(MEMBER_ID)
	REFERENCES TBL_MEMBER(ID)
);

/*동물원*/
CREATE TABLE TBL_ZOO(
	ID NUMBER CONSTRAINT PK_ZOO PRIMARY KEY,
	ZOO_NAME VARCHAR2(255),
	ZOO_ADDRESS VARCHAR2(255),
	ZOO_ADDRESS_DETAIL VARCHAR2(255),
	ZOO_MAX_ANIMAL NUMBER DEFAULT 0
);

/*동물*/
CREATE TABLE TBL_ANIMAL(
	ID NUMBER CONSTRAINT PK_ANIMAL PRIMARY KEY,
	ANIMAL_NAME VARCHAR2(255),
	ANIMAL_TYPE VARCHAR2(255),
	ANIMAL_AGE NUMBER DEFAULT 0,
	ANIMAL_HEIGHT NUMBER(3, 5),
	ANIMAL_WEIGHT NUMBER(3, 5),
	ZOO_ID NUMBER,
	CONSTRAINT FK_ANIMAL_ZOO FOREIGN KEY(ZOO_ID)
	REFERENCES TBL_ZOO(ID)
);

/*
  	<논리적 설계>
	회원		    주문		        상품
	----------------------------------------
	번호PK		번호PK		    번호PK
	----------------------------------------
	아이디U, NN	날짜NN		    이름NN
	비밀번호NN		회원번호FK, NN		가격D=0
	이름NN		상품번호FK, NN		재고D=0
	주소NN
	이메일
	생일
*/
/*
 * <물리적 설계>
 * 
 * */
DROP TABLE TBL_ORDER;
DROP TABLE TBL_MEMBER;

CREATE TABLE TBL_MEMBER(
	ID NUMBER CONSTRAINT PK_MEMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(255) CONSTRAINT UK_MEMBER UNIQUE NOT NULL,
	MEMBER_PASSWORD VARCHAR2(255) NOT NULL,
	MEMBER_NAME VARCHAR2(255) NOT NULL,
	MEMBER_ADDRESS VARCHAR2(255) NOT NULL,
	MEMBER_EMAIL VARCHAR2(255),
	MEMBER_BIRTH DATE
);

CREATE TABLE TBL_PRODUCT(
	ID NUMBER CONSTRAINT PK_PRODUCT PRIMARY KEY,
	PRODUCT_NAME VARCHAR2(255) NOT NULL,
	PRODUCT_PRICE NUMBER DEFAULT 0,
	PRODUCT_STOCK NUMBER DEFAULT 0
);

CREATE TABLE TBL_ORDER(
	ID NUMBER CONSTRAINT PK_ORDER PRIMARY KEY,
	ORDER_DATE DATE DEFAULT CURRENT_TIMESTAMP,
	MEMBER_ID NUMBER,
	PRODUCT_ID NUMBER,
	CONSTRAINT FK_ORDER_MEMBER FOREIGN KEY(MEMBER_ID)
	REFERENCES TBL_MEMBER(ID),
	CONSTRAINT FK_ORDER_PRODUCT FOREIGN KEY(PRODUCT_ID)
	REFERENCES TBL_PRODUCT(ID)
);

/*숙제*/
/*1. 요구사항 분석
    꽃 테이블과 화분 테이블 2개가 필요하고,
    꽃을 구매할 때 화분도 같이 구매합니다.
    꽃은 이름과 색상, 가격이 있고,
    화분은 제품번호, 색상, 모양이 있습니다.
    화분은 모든 꽃을 담을 수 없고 정해진 꽃을 담아야 합니다.

2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현*/

/*구현된 테이블 구조 해석
 * 
 * 하나의 꽃은 여러 화분에 담길 수 있으나,
 * 하나의 화분에는 하나의 꽃만 담을 수 있는
 * 전형적인 1:N 구조이다.
 * 
 * */
CREATE TABLE TBL_FLOWER(
	ID NUMBER CONSTRAINT PK_FLOWER PRIMARY KEY,
	NAME VARCHAR2(255) NOT NULL CONSTRAINT UK_FLOWER UNIQUE,
	COLOR VARCHAR2(255) NOT NULL,
	PRICE NUMBER DEFAULT 0
);

CREATE TABLE TBL_FLOWER_POT(
	ID NUMBER CONSTRAINT PK_FLOWER_POT PRIMARY KEY,
	COLOR VARCHAR2(255) NOT NULL,
	SHAPE VARCHAR2(255) NOT NULL,
	FLOWER_ID NUMBER,
	CONSTRAINT FK_POT_FLOWER FOREIGN KEY(FLOWER_ID)
	REFERENCES TBL_FLOWER(ID)
);

/*복합키(조합키)
 * 
 * PK를 설정할 때 컬럼을 2개 이상 설정하는 문법.
 * 여러 개의 컬럼 조합으로 중복이 없는 경우 하나의 PK처럼 사용할 수 있게 된다.
 * 
 * */

/*구현된 테이블 구조 해석
 * 
 * 하나의 꽃은 여러 화분에 담길 수 있으나,
 * 하나의 화분에는 하나의 꽃만 담을 수 있는
 * 전형적인 1:N 구조이다.
 * 
 * */
DROP TABLE TBL_FLOWER_POT;
DROP TABLE TBL_FLOWER;

CREATE TABLE TBL_FLOWER(
	NAME VARCHAR2(255) NOT NULL,
	COLOR VARCHAR2(255) NOT NULL,
	PRICE NUMBER DEFAULT 0,
	CONSTRAINT PK_FLOWER PRIMARY KEY(NAME, COLOR)
);

CREATE TABLE TBL_FLOWER_POT(
	ID NUMBER CONSTRAINT PK_FLOWER_POT PRIMARY KEY,
	COLOR VARCHAR2(255) NOT NULL,
	SHAPE VARCHAR2(255) NOT NULL,
	FLOWER_NAME VARCHAR2(255) NOT NULL,
	FLOWER_COLOR VARCHAR2(255) NOT NULL,
	CONSTRAINT FK_POT_FLOWER FOREIGN KEY(FLOWER_NAME, FLOWER_COLOR)
	REFERENCES TBL_FLOWER(NAME, COLOR)
);

/*슈퍼키, 서브키
 * 
 * FK를 PK로 설정한다.
 * 
 * */

/*구현된 테이블 구조 해석
 * 
 * 하나의 꽃은 하나의 화분에 담길 수 있고,
 * 하나의 화분에는 하나의 꽃만 담을 수 있는
 * 전형적인 1:1 구조이다.
 * 
 * */
CREATE TABLE TBL_FLOWER(
	ID NUMBER CONSTRAINT PK_FLOWER PRIMARY KEY,
	NAME VARCHAR2(255) NOT NULL CONSTRAINT UK_FLOWER UNIQUE,
	COLOR VARCHAR2(255) NOT NULL,
	PRICE NUMBER DEFAULT 0
);

CREATE TABLE TBL_FLOWER_POT(
	ID NUMBER CONSTRAINT PK_FLOWER_POT PRIMARY KEY,
	COLOR VARCHAR2(255) NOT NULL,
	SHAPE VARCHAR2(255) NOT NULL,
	CONSTRAINT FK_POT_FLOWER FOREIGN KEY(ID)
	REFERENCES TBL_FLOWER(ID)
);

/*
1. 요구사항 분석
    안녕하세요, 동물병원을 곧 개원합니다.
    동물은 보호자랑 항상 같이 옵니다. 가끔 보호소에서 오는 동물도 있습니다.
    보호자가 여러 마리의 동물을 데리고 올 수 있습니다.
    보호자는 이름, 나이, 전화번호, 주소가 필요하고
    동물은 병명, 이름, 나이, 몸무게가 필요합니다.

2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/
CREATE TABLE TBL_OWNER(
	ID NUMBER CONSTRAINT PK_OWNER PRIMARY KEY,
	NAME VARCHAR2(255) NOT NULL,
	AGE NUMBER,
	PHONE VARCHAR2(255) NOT NULL
);

ALTER TABLE TBL_OWNER ADD(ADDRESS VARCHAR2(255));
ALTER TABLE TBL_OWNER RENAME COLUMN NAME TO OWNER_NAME;
ALTER TABLE TBL_OWNER RENAME COLUMN AGE TO OWNER_AGE;
ALTER TABLE TBL_OWNER RENAME COLUMN PHONE TO OWNER_PHONE;
ALTER TABLE TBL_OWNER RENAME COLUMN ADDRESS TO OWNER_ADDRESS;

CREATE TABLE TBL_PET(
	ID NUMBER CONSTRAINT PK_PET PRIMARY KEY,
	PET_ILL_NAME VARCHAR2(255),
	PET_NAME VARCHAR2(255),
	PET_AGE NUMBER,
	WEIGHT NUMBER(4, 2),
	OWNER_ID NUMBER,
	CONSTRAINT FK_PET_OWNER FOREIGN KEY(OWNER_ID)
	REFERENCES TBL_OWNER(ID)
);

ALTER TABLE TBL_PET RENAME COLUMN WEIGHT TO PET_WEIGHT;

/*
1. 요구 사항
    커뮤니티 게시판을 만들고 싶어요.
    게시판에는 게시글 제목과 게시글 내용, 작성한 시간, 작성자가 있고,
    게시글에는 댓글이 있어서 댓글 내용들이 나와야 해요.
    작성자는 회원(TBL_MEMBER)정보를 그대로 사용해요.
    댓글에도 작성자가 필요해요.

2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/
CREATE TABLE TBL_MEMBER(
	ID NUMBER CONSTRAINT PK_MEMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(255) CONSTRAINT UK_MEMBER UNIQUE NOT NULL,
	MEMBER_PASSWORD VARCHAR2(255) NOT NULL,
	MEMBER_NAME VARCHAR2(255) NOT NULL,
	MEMBER_ADDRESS VARCHAR2(255) NOT NULL,
	MEMBER_EMAIL VARCHAR2(255),
	MEMBER_BIRTH DATE
);

CREATE TABLE TBL_POST(
	ID NUMBER CONSTRAINT PK_POST PRIMARY KEY,
	POST_TITLE VARCHAR2(255) NOT NULL,
	POST_CONTENT VARCHAR2(255) NOT NULL,
	CREATED_DATE DATE DEFAULT CURRENT_TIMESTAMP,
	MEMBER_ID NUMBER,
	CONSTRAINTS FK_POST_MEMBER FOREIGN KEY(MEMBER_ID)
	REFERENCES TBL_MEMBER(ID)
);

ALTER TABLE TBL_POST MODIFY(MEMBER_ID NULL);
ALTER TABLE TBL_POST MODIFY(MEMBER_ID NOT NULL);

CREATE TABLE TBL_REPLY(
	ID NUMBER CONSTRAINT PK_REPLY PRIMARY KEY,
	REPLY_CONTENT VARCHAR2(255) NOT NULL,
	POST_ID NUMBER NOT NULL,
	MEMBER_ID NUMBER NOT NULL,
	CONSTRAINTS FK_REPLY_POST FOREIGN KEY(POST_ID)
	REFERENCES TBL_POST(ID),
	CONSTRAINTS FK_REPLY_MEMBER FOREIGN KEY(MEMBER_ID)
	REFERENCES TBL_MEMBER(ID)
);

/*
1. 요구 사항
    마이페이지에서 회원 프로필을 구현하고 싶습니다.
    회원당 프로필을 여러 개 설정할 수 있고,
    대표 이미지로 선택된 프로필만 화면에 보여주고 싶습니다.

2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/
DROP TABLE TBL_MEMBER;
DROP TABLE TBL_POST;
DROP TABLE TBL_REPLY;

CREATE TABLE TBL_MEMBER(
	ID NUMBER CONSTRAINT PK_MEMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(255) CONSTRAINT UK_MEMBER UNIQUE NOT NULL,
	MEMBER_PASSWORD VARCHAR2(255) NOT NULL,
	MEMBER_NAME VARCHAR2(255) NOT NULL,
	MEMBER_ADDRESS VARCHAR2(255) NOT NULL,
	MEMBER_EMAIL VARCHAR2(255),
	MEMBER_BIRTH DATE
);

CREATE TABLE TBL_PROFILE(
	ID NUMBER CONSTRAINT PK_PROFILE PRIMARY KEY,
	PROFILE_PATH VARCHAR2(255) NOT NULL,
	PROFILE_SIZE NUMBER DEFAULT 0,
	STATUS NUMBER DEFAULT 0,
	MEMBER_ID NUMBER NOT NULL,
	CONSTRAINT FK_PROFILE_MEMBER FOREIGN KEY(MEMBER_ID)
	REFERENCES TBL_MEMBER(ID)
);

/*
1. 요구 사항
    회원들끼리 좋아요를 누를 수 있습니다.

2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/

DROP TABLE TBL_MEMBER;
DROP TABLE TBL_PROFILE;

CREATE TABLE TBL_MEMBER(
	ID NUMBER CONSTRAINT PK_MEMBER PRIMARY KEY,
	MEMBER_ID VARCHAR2(255) CONSTRAINT UK_MEMBER UNIQUE NOT NULL,
	MEMBER_PASSWORD VARCHAR2(255) NOT NULL,
	MEMBER_NAME VARCHAR2(255) NOT NULL,
	MEMBER_ADDRESS VARCHAR2(255) NOT NULL,
	MEMBER_EMAIL VARCHAR2(255),
	MEMBER_BIRTH DATE
);

CREATE TABLE TBL_LIKE(
	ID NUMBER CONSTRAINT PK_LIKE PRIMARY KEY,
	LIKE_RECEIVER NUMBER NOT NULL,
	LIKE_SENDER NUMBER NOT NULL,
	CONSTRAINT FK_LIKE_MEMBER_RECEIVER FOREIGN KEY(LIKE_RECEIVER)
	REFERENCES TBL_MEMBER(ID),
	CONSTRAINT FK_LIKE_MEMBER_SENDER FOREIGN KEY(LIKE_SENDER)
	REFERENCES TBL_MEMBER(ID)
);

ALTER TABLE TBL_LIKE RENAME COLUMN LIKE_RECIEVER TO LIKE_RECEIVER;
ALTER TABLE TBL_LIKE DROP CONSTRAINT FK_LIKE_MEMBER_RECIEVER;

ALTER TABLE TBL_LIKE ADD 
CONSTRAINT FK_LIKE_MEMBER_RECEIVER FOREIGN KEY(LIKE_RECEIVER)
REFERENCES TBL_MEMBER(ID);

/*
    1. 요구사항 분석
        안녕하세요 중고차 딜러입니다.
        이번에 자동차와 차주를 관리하고자 방문했습니다.
        자동차는 여러 명의 차주로 히스토리에 남아야 하고,
        차주는 여러 대의 자동차를 소유할 수 있습니다.
        그래서 우리는 항상 등록증(Registration)을 작성합니다.
        자동차는 브랜드, 모델명, 가격, 출시날짜가 필요하고
        차주는 이름, 전화번호, 주소가 필요합니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/
CREATE TABLE TBL_CAR(
	ID NUMBER CONSTRAINT PK_CAR PRIMARY KEY,
	CAR_BRAND VARCHAR2(255) NOT NULL,
	CAR_NAME VARCHAR2(255) NOT NULL,
	CAR_PRICE NUMBER DEFAULT 0,
	CAR_RELEASE_DATE DATE
);

CREATE TABLE TBL_OWNER(
	ID NUMBER CONSTRAINT PK_OWNER PRIMARY KEY,
	OWNER_ID VARCHAR2(255) CONSTRAINT UK_OWNER UNIQUE NOT NULL,
	OWNER_PASSWORD VARCHAR2(255) NOT NULL,
	OWNER_NAME VARCHAR2(255) NOT NULL,
	OWNER_ADDRESS VARCHAR2(255) NOT NULL,
	OWNER_EMAIL VARCHAR2(255),
	OWNER_BIRTH DATE
);

CREATE TABLE TBL_REGISTRATION(
	ID NUMBER CONSTRAINT PK_REGISTRATION PRIMARY KEY,
	OWNER_ID NUMBER,
	CAR_ID NUMBER,
	CONSTRAINT FK_REGISTRATION_OWNER FOREIGN KEY(OWNER_ID)
	REFERENCES TBL_OWNER(ID),
	CONSTRAINT FK_REGISTRATION_CAR FOREIGN KEY(CAR_ID)
	REFERENCES TBL_CAR(ID)
);

/*
1. 요구사항

    학사 관리 시스템에 학생과 교수, 과목을 관리합니다.
    학생은 학번, 이름, 전공, 학년이 필요하고
    교수는 교수 번호, 이름, 전공, 직위가 필요합니다.
    과목은 고유한 과목 번호와 과목명, 학점이 필요합니다.
    학생은 여러 과목을 수강할 수 있으며,
    교수는 여러 과목을 강의할 수 있습니다.
    학생이 수강한 과목은 성적(점수)이 모두 기록됩니다.
    
2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/
CREATE TABLE TBL_STUDENT(
	ID NUMBER CONSTRAINT PK_STUDENT PRIMARY KEY,
	STUDENT_NAME VARCHAR2(255) NOT NULL,
	STUDENT_MAJOR VARCHAR2(255) NOT NULL,
	STUDENT_GRADE NUMBER DEFAULT 1
);

CREATE TABLE TBL_PROFESSOR(
	ID NUMBER CONSTRAINT PK_PROFESSOR PRIMARY KEY,
	PROFESSOR_NAME VARCHAR2(255) NOT NULL,
	PROFESSOR_MAJOR VARCHAR2(255) NOT NULL,
	PROFESSOR_POSITION VARCHAR2(255)
);

CREATE TABLE TBL_SUBJECT(
	ID NUMBER CONSTRAINT PK_SUBJECT PRIMARY KEY,
	SUBJECT_NAME VARCHAR2(255) NOT NULL CONSTRAINT UK_SUBJECT UNIQUE,
	SUBJECT_SCORE NUMBER(3, 2) DEFAULT 0.0
);

ALTER TABLE TBL_SUBJECT ADD (STATUS NUMBER DEFAULT 0);


CREATE TABLE TBL_STUDENT_SUBJECT(
	ID NUMBER CONSTRAINT PK_STUDENT_SUBJECT PRIMARY KEY,
	STUDENT_ID NUMBER NOT NULL,
	SUBJECT_ID NUMBER NOT NULL,
	CONSTRAINT FK_STUDENT_SUBJECT_STUDENT FOREIGN KEY(STUDENT_ID)
	REFERENCES TBL_STUDENT(ID),
	CONSTRAINT FK_STUDENT_SUBJECT_SUBJECT FOREIGN KEY(SUBJECT_ID)
	REFERENCES TBL_SUBJECT(ID)
);

CREATE TABLE TBL_LECTURE(
	ID NUMBER CONSTRAINT PK_LECTURE PRIMARY KEY,
	PROFESSOR_ID NUMBER,
	SUBJECT_ID NUMBER NOT NULL,
	CONSTRAINT FK_LECTURE_PROFESSOR FOREIGN KEY(PROFESSOR_ID)
	REFERENCES TBL_PROFESSOR(ID),
	CONSTRAINT FK_LECTURE_SUBJECT FOREIGN KEY(SUBJECT_ID)
	REFERENCES TBL_SUBJECT(ID)
);
/*
1. 요구사항
    대카테고리, 소카테고리가 필요해요.
    
2. 개념 모델링
3. 논리 모델링
4. 물리 모델링
5. 구현
*/

/*대카*/
CREATE TABLE TBL_CATEGORY_A(
	ID NUMBER CONSTRAINT PK_CATEGORY_A PRIMARY KEY,
	CATEGORY_A_NAME VARCHAR2(255)
);

/*소카*/
CREATE TABLE TBL_CATEGORY_B(
	ID NUMBER CONSTRAINT PK_CATEGORY_B PRIMARY KEY,
	CATEGORY_B_NAME VARCHAR2(255),
	CATEGORY_A_ID NUMBER,
	CONSTRAINT FK_CATEGORY_B_CATEGORY_A FOREIGN KEY(CATEGORY_A_ID)
	REFERENCES TBL_CATEGORY_A(ID)
);

/*
 * 요구 사항
 * 
 * 회의실 예약 서비스를 제작하고 싶습니다.
 * 회원별로 등급이 존재하고 사무실마다 회의실이 여러 개 있습니다.
 * 회의실 이용 가능 시간은 파트 타임으로서 여러 시간대가 존재합니다.
 * 
 * */

/*
 * 요구사항 3개씩 제작 및 해결
 * 
 * */











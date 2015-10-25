--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    money double precision DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


ALTER TABLE accounts OWNER TO qatime;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accounts_id_seq OWNER TO qatime;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE answers (
    id integer NOT NULL,
    question_id integer,
    teacher_id integer,
    token character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments_count integer DEFAULT 0
);


ALTER TABLE answers OWNER TO qatime;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answers_id_seq OWNER TO qatime;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: cash_operation_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE cash_operation_records (
    id integer NOT NULL,
    operator_id integer,
    account_id integer,
    value double precision,
    type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE cash_operation_records OWNER TO qatime;

--
-- Name: cash_operation_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE cash_operation_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cash_operation_records_id_seq OWNER TO qatime;

--
-- Name: cash_operation_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE cash_operation_records_id_seq OWNED BY cash_operation_records.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE cities OWNER TO qatime;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cities_id_seq OWNER TO qatime;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    content text,
    author_id integer,
    commentable_id integer,
    commentable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE comments OWNER TO qatime;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO qatime;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: consumption_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE consumption_records (
    id integer NOT NULL,
    fee_id integer,
    account_id integer,
    value double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE consumption_records OWNER TO qatime;

--
-- Name: consumption_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE consumption_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE consumption_records_id_seq OWNER TO qatime;

--
-- Name: consumption_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE consumption_records_id_seq OWNED BY consumption_records.id;


--
-- Name: corrections; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE corrections (
    id integer NOT NULL,
    content text,
    teacher_id integer,
    solution_id integer,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments_count integer DEFAULT 0,
    customized_course_id integer,
    homework_id integer,
    status character varying DEFAULT 'open'::character varying NOT NULL,
    type character varying,
    customized_tutorial_id integer,
    examination_id integer
);


ALTER TABLE corrections OWNER TO qatime;

--
-- Name: corrections_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE corrections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE corrections_id_seq OWNER TO qatime;

--
-- Name: corrections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE corrections_id_seq OWNED BY corrections.id;


--
-- Name: course_purchase_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE course_purchase_records (
    id integer NOT NULL,
    student_id integer,
    course_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE course_purchase_records OWNER TO qatime;

--
-- Name: course_purchase_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE course_purchase_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE course_purchase_records_id_seq OWNER TO qatime;

--
-- Name: course_purchase_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE course_purchase_records_id_seq OWNED BY course_purchase_records.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    name character varying(255),
    "desc" text,
    lessons_count integer DEFAULT 0,
    token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    price double precision DEFAULT 30.0,
    teacher_id integer,
    state character varying(255) DEFAULT 'unpublished'::character varying,
    course_purchase_records_count integer,
    curriculum_id integer,
    chapter character varying,
    "position" integer DEFAULT 0,
    delete_topics_count integer DEFAULT 0
);


ALTER TABLE courses OWNER TO qatime;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE courses_id_seq OWNER TO qatime;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: curriculums; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE curriculums (
    id integer NOT NULL,
    teacher_id integer,
    teaching_program_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    courses_count integer DEFAULT 0,
    lessons_count integer DEFAULT 0,
    delete_topics_count integer DEFAULT 0
);


ALTER TABLE curriculums OWNER TO qatime;

--
-- Name: curriculums_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE curriculums_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculums_id_seq OWNER TO qatime;

--
-- Name: curriculums_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE curriculums_id_seq OWNED BY curriculums.id;


--
-- Name: customized_course_assignments; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE customized_course_assignments (
    id integer NOT NULL,
    customized_course_id integer,
    teacher_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE customized_course_assignments OWNER TO qatime;

--
-- Name: customized_course_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE customized_course_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customized_course_assignments_id_seq OWNER TO qatime;

--
-- Name: customized_course_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE customized_course_assignments_id_seq OWNED BY customized_course_assignments.id;


--
-- Name: customized_courses; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE customized_courses (
    id integer NOT NULL,
    student_id integer,
    category character varying,
    subject character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    customized_tutorials_count integer DEFAULT 0,
    topics_count integer DEFAULT 0,
    homeworks_count integer DEFAULT 0,
    exercises_count integer DEFAULT 0,
    tutorial_issues_count integer DEFAULT 0,
    course_issues_count integer DEFAULT 0
);


ALTER TABLE customized_courses OWNER TO qatime;

--
-- Name: customized_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE customized_courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customized_courses_id_seq OWNER TO qatime;

--
-- Name: customized_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE customized_courses_id_seq OWNED BY customized_courses.id;


--
-- Name: customized_tutorials; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE customized_tutorials (
    id integer NOT NULL,
    teacher_id integer,
    customized_course_id integer,
    title character varying,
    content text,
    "position" integer DEFAULT 0,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    topics_count integer DEFAULT 0,
    exercises_count integer DEFAULT 0,
    tutorial_issues_count integer DEFAULT 0,
    status character varying DEFAULT 'open'::character varying NOT NULL
);


ALTER TABLE customized_tutorials OWNER TO qatime;

--
-- Name: customized_tutorials_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE customized_tutorials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE customized_tutorials_id_seq OWNER TO qatime;

--
-- Name: customized_tutorials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE customized_tutorials_id_seq OWNED BY customized_tutorials.id;


--
-- Name: earning_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE earning_records (
    id integer NOT NULL,
    fee_id integer,
    account_id integer,
    percent double precision,
    value double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE earning_records OWNER TO qatime;

--
-- Name: earning_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE earning_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE earning_records_id_seq OWNER TO qatime;

--
-- Name: earning_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE earning_records_id_seq OWNED BY earning_records.id;


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE examinations (
    id integer NOT NULL,
    customized_course_id integer,
    teacher_id integer,
    title character varying,
    content text,
    token character varying,
    topics_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    solutions_count integer DEFAULT 0,
    student_id integer,
    customized_tutorial_id integer,
    comments_count integer DEFAULT 0,
    corrections_count integer DEFAULT 0,
    work_type character varying,
    type character varying
);


ALTER TABLE examinations OWNER TO qatime;

--
-- Name: examinations_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE examinations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE examinations_id_seq OWNER TO qatime;

--
-- Name: examinations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE examinations_id_seq OWNED BY examinations.id;


--
-- Name: excercises; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE excercises (
    id integer NOT NULL,
    token character varying,
    title character varying,
    content character varying,
    teacher_id integer,
    customized_tutorial_id integer,
    solutions_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE excercises OWNER TO qatime;

--
-- Name: excercises_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE excercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE excercises_id_seq OWNER TO qatime;

--
-- Name: excercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE excercises_id_seq OWNED BY excercises.id;


--
-- Name: exercises; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE exercises (
    id integer NOT NULL,
    token character varying,
    title character varying,
    content text,
    teacher_id integer,
    customized_tutorial_id integer,
    solutions_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments_count integer DEFAULT 0,
    student_id integer,
    customized_course_id integer
);


ALTER TABLE exercises OWNER TO qatime;

--
-- Name: exercises_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE exercises_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE exercises_id_seq OWNER TO qatime;

--
-- Name: exercises_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE exercises_id_seq OWNED BY exercises.id;


--
-- Name: faq_topics; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE faq_topics (
    id integer NOT NULL,
    title character varying(255),
    user_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


ALTER TABLE faq_topics OWNER TO qatime;

--
-- Name: faq_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE faq_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE faq_topics_id_seq OWNER TO qatime;

--
-- Name: faq_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE faq_topics_id_seq OWNED BY faq_topics.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE faqs (
    id integer NOT NULL,
    name character varying(255),
    "desc" text,
    token character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    faq_type character varying(255),
    faq_topic_id integer,
    is_top integer DEFAULT 0,
    video_url character varying(255)
);


ALTER TABLE faqs OWNER TO qatime;

--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE faqs_id_seq OWNER TO qatime;

--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE faqs_id_seq OWNED BY faqs.id;


--
-- Name: fees; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE fees (
    id integer NOT NULL,
    customized_course_id integer,
    feeable_id integer,
    feeable_type character varying,
    value double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    price_per_minute double precision,
    video_duration double precision
);


ALTER TABLE fees OWNER TO qatime;

--
-- Name: fees_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE fees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fees_id_seq OWNER TO qatime;

--
-- Name: fees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE fees_id_seq OWNED BY fees.id;


--
-- Name: learning_plan_assignments; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE learning_plan_assignments (
    id integer NOT NULL,
    learning_plan_id integer,
    teacher_id integer,
    answered_questions_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE learning_plan_assignments OWNER TO qatime;

--
-- Name: learning_plan_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE learning_plan_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE learning_plan_assignments_id_seq OWNER TO qatime;

--
-- Name: learning_plan_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE learning_plan_assignments_id_seq OWNED BY learning_plan_assignments.id;


--
-- Name: learning_plans; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE learning_plans (
    id integer NOT NULL,
    duration_type character varying,
    state character varying,
    student_id integer,
    vip_class_id integer,
    price double precision,
    begin_at timestamp without time zone,
    end_at timestamp without time zone,
    questions_count integer DEFAULT 0,
    answered_questions_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE learning_plans OWNER TO qatime;

--
-- Name: learning_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE learning_plans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE learning_plans_id_seq OWNER TO qatime;

--
-- Name: learning_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE learning_plans_id_seq OWNED BY learning_plans.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    name character varying(255),
    "desc" text,
    course_id integer,
    token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    teacher_id integer,
    curriculum_id integer,
    state character varying DEFAULT 'init'::character varying,
    topics_count integer DEFAULT 0,
    tags jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE lessons OWNER TO qatime;

--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lessons_id_seq OWNER TO qatime;

--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE lessons_id_seq OWNED BY lessons.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    sender_id integer,
    receiver_id integer,
    message_type character varying(255),
    status character varying(255),
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE messages OWNER TO qatime;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE messages_id_seq OWNER TO qatime;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: nodes; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE nodes (
    id integer NOT NULL,
    name character varying(255),
    summary character varying(255),
    topics_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    section_id integer,
    tutorials_count integer DEFAULT 0,
    courses_count integer DEFAULT 0,
    en_name character varying(255)
);


ALTER TABLE nodes OWNER TO qatime;

--
-- Name: nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nodes_id_seq OWNER TO qatime;

--
-- Name: nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE nodes_id_seq OWNED BY nodes.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE pictures (
    id integer NOT NULL,
    name character varying(255),
    imageable_id integer,
    imageable_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    token character varying(255)
);


ALTER TABLE pictures OWNER TO qatime;

--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pictures_id_seq OWNER TO qatime;

--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE pictures_id_seq OWNED BY pictures.id;


--
-- Name: qa_faqs; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE qa_faqs (
    id integer NOT NULL,
    title character varying,
    content text,
    qa_faq_type integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    token character varying
);


ALTER TABLE qa_faqs OWNER TO qatime;

--
-- Name: qa_faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE qa_faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE qa_faqs_id_seq OWNER TO qatime;

--
-- Name: qa_faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE qa_faqs_id_seq OWNED BY qa_faqs.id;


--
-- Name: qa_files; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE qa_files (
    id integer NOT NULL,
    author_id integer,
    qa_fileable_id integer,
    qa_fileable_type character varying,
    name character varying,
    qa_file_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_filename character varying
);


ALTER TABLE qa_files OWNER TO qatime;

--
-- Name: qa_files_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE qa_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE qa_files_id_seq OWNER TO qatime;

--
-- Name: qa_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE qa_files_id_seq OWNED BY qa_files.id;


--
-- Name: question_assignments; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE question_assignments (
    id integer NOT NULL,
    question_id integer,
    teacher_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE question_assignments OWNER TO qatime;

--
-- Name: question_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE question_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_assignments_id_seq OWNER TO qatime;

--
-- Name: question_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE question_assignments_id_seq OWNED BY question_assignments.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE questions (
    id integer NOT NULL,
    title character varying,
    content text,
    token character varying,
    student_id integer,
    answers_count integer DEFAULT 0,
    vip_class_id integer,
    learning_plan_id integer,
    answers_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_answer_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments_count integer DEFAULT 0
);


ALTER TABLE questions OWNER TO qatime;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questions_id_seq OWNER TO qatime;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: recharge_codes; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE recharge_codes (
    id integer NOT NULL,
    money integer DEFAULT 500,
    code character varying(255),
    admin_id integer,
    "desc" character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    student_id integer,
    lock_version integer DEFAULT 0
);


ALTER TABLE recharge_codes OWNER TO qatime;

--
-- Name: recharge_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE recharge_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recharge_codes_id_seq OWNER TO qatime;

--
-- Name: recharge_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE recharge_codes_id_seq OWNED BY recharge_codes.id;


--
-- Name: recharge_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE recharge_records (
    id integer NOT NULL,
    student_id integer,
    code character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    recharge_code_id integer
);


ALTER TABLE recharge_records OWNER TO qatime;

--
-- Name: recharge_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE recharge_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recharge_records_id_seq OWNER TO qatime;

--
-- Name: recharge_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE recharge_records_id_seq OWNED BY recharge_records.id;


--
-- Name: register_codes; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE register_codes (
    id integer NOT NULL,
    value character varying NOT NULL,
    state character varying DEFAULT 'available'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    school_id integer,
    batch_id character varying
);


ALTER TABLE register_codes OWNER TO qatime;

--
-- Name: register_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE register_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE register_codes_id_seq OWNER TO qatime;

--
-- Name: register_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE register_codes_id_seq OWNED BY register_codes.id;


--
-- Name: replies; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE replies (
    id integer NOT NULL,
    content text,
    topic_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    token character varying(255),
    author_id integer,
    customized_course_id integer,
    status character varying DEFAULT 'open'::character varying NOT NULL,
    type character varying,
    customized_tutorial_id integer
);


ALTER TABLE replies OWNER TO qatime;

--
-- Name: replies_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE replies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE replies_id_seq OWNER TO qatime;

--
-- Name: replies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE replies_id_seq OWNED BY replies.id;


--
-- Name: review_records; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE review_records (
    id integer NOT NULL,
    lesson_id integer,
    manager_id integer,
    complete_state character varying,
    start_state character varying,
    reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE review_records OWNER TO qatime;

--
-- Name: review_records_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE review_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE review_records_id_seq OWNER TO qatime;

--
-- Name: review_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE review_records_id_seq OWNED BY review_records.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE schema_migrations OWNER TO qatime;

--
-- Name: schools; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE schools (
    id integer NOT NULL,
    name character varying(255),
    city_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE schools OWNER TO qatime;

--
-- Name: schools_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE schools_id_seq OWNER TO qatime;

--
-- Name: schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE schools_id_seq OWNED BY schools.id;


--
-- Name: searches; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE searches (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE searches OWNER TO qatime;

--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE searches_id_seq OWNER TO qatime;

--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE searches_id_seq OWNED BY searches.id;


--
-- Name: solutions; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE solutions (
    id integer NOT NULL,
    title character varying,
    content text,
    solutionable_id integer,
    student_id integer,
    token character varying,
    corrections_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comments_count integer DEFAULT 0,
    solutionable_type character varying,
    customized_course_id integer,
    first_handle_created_at timestamp without time zone,
    last_handle_created_at timestamp without time zone,
    first_handle_author_id integer,
    last_handle_author_id integer,
    type character varying,
    examination_id integer,
    customized_tutorial_id integer
);


ALTER TABLE solutions OWNER TO qatime;

--
-- Name: solutions_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE solutions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE solutions_id_seq OWNER TO qatime;

--
-- Name: solutions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE solutions_id_seq OWNED BY solutions.id;


--
-- Name: teaching_programs; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE teaching_programs (
    id integer NOT NULL,
    name character varying,
    category character varying,
    grade character varying,
    subject character varying,
    content jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE teaching_programs OWNER TO qatime;

--
-- Name: teaching_programs_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE teaching_programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teaching_programs_id_seq OWNER TO qatime;

--
-- Name: teaching_programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE teaching_programs_id_seq OWNED BY teaching_programs.id;


--
-- Name: teaching_videos; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE teaching_videos (
    id integer NOT NULL,
    name character varying,
    token character varying,
    vip_class integer,
    teacher_id integer,
    question_id integer,
    answer_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    video_type character varying DEFAULT 'mp4'::character varying,
    state character varying DEFAULT 'not_convert'::character varying,
    convert_name character varying
);


ALTER TABLE teaching_videos OWNER TO qatime;

--
-- Name: teaching_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE teaching_videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teaching_videos_id_seq OWNER TO qatime;

--
-- Name: teaching_videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE teaching_videos_id_seq OWNED BY teaching_videos.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    title character varying(255),
    content text,
    replies_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    token character varying(255),
    course_id integer,
    author_id integer,
    curriculum_id integer,
    topicable_id integer,
    delete_learning_plan_id integer,
    teacher_id integer,
    topicable_type character varying,
    customized_course_id integer,
    type character varying,
    customized_tutorial_id integer
);


ALTER TABLE topics OWNER TO qatime;

--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topics_id_seq OWNER TO qatime;

--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    topics_count integer DEFAULT 0,
    replies_count integer DEFAULT 0,
    name character varying(255),
    avatar character varying(255),
    school_id integer,
    role character varying(255),
    password_digest character varying(255),
    remember_token character varying(255),
    "desc" text,
    course_purchase_records_count integer,
    joined_groups_count integer DEFAULT 0,
    subject character varying,
    category character varying,
    mobile character varying,
    pass boolean DEFAULT false,
    grade character varying,
    nick_name character varying
);


ALTER TABLE users OWNER TO qatime;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO qatime;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE videos (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    token character varying(255),
    videoable_id integer,
    video_type character varying(255) DEFAULT 'mp4'::character varying,
    convert_name character varying,
    state character varying DEFAULT 'not_convert'::character varying,
    videoable_type character varying,
    author_id integer,
    duration integer
);


ALTER TABLE videos OWNER TO qatime;

--
-- Name: videos_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE videos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE videos_id_seq OWNER TO qatime;

--
-- Name: videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE videos_id_seq OWNED BY videos.id;


--
-- Name: vip_classes; Type: TABLE; Schema: public; Owner: qatime; Tablespace: 
--

CREATE TABLE vip_classes (
    id integer NOT NULL,
    subject character varying,
    category character varying,
    questions_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE vip_classes OWNER TO qatime;

--
-- Name: vip_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: qatime
--

CREATE SEQUENCE vip_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vip_classes_id_seq OWNER TO qatime;

--
-- Name: vip_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: qatime
--

ALTER SEQUENCE vip_classes_id_seq OWNED BY vip_classes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY cash_operation_records ALTER COLUMN id SET DEFAULT nextval('cash_operation_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY consumption_records ALTER COLUMN id SET DEFAULT nextval('consumption_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY corrections ALTER COLUMN id SET DEFAULT nextval('corrections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY course_purchase_records ALTER COLUMN id SET DEFAULT nextval('course_purchase_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY curriculums ALTER COLUMN id SET DEFAULT nextval('curriculums_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY customized_course_assignments ALTER COLUMN id SET DEFAULT nextval('customized_course_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY customized_courses ALTER COLUMN id SET DEFAULT nextval('customized_courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY customized_tutorials ALTER COLUMN id SET DEFAULT nextval('customized_tutorials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY earning_records ALTER COLUMN id SET DEFAULT nextval('earning_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY examinations ALTER COLUMN id SET DEFAULT nextval('examinations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY excercises ALTER COLUMN id SET DEFAULT nextval('excercises_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY exercises ALTER COLUMN id SET DEFAULT nextval('exercises_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY faq_topics ALTER COLUMN id SET DEFAULT nextval('faq_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY faqs ALTER COLUMN id SET DEFAULT nextval('faqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY fees ALTER COLUMN id SET DEFAULT nextval('fees_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY learning_plan_assignments ALTER COLUMN id SET DEFAULT nextval('learning_plan_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY learning_plans ALTER COLUMN id SET DEFAULT nextval('learning_plans_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY lessons ALTER COLUMN id SET DEFAULT nextval('lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY nodes ALTER COLUMN id SET DEFAULT nextval('nodes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY pictures ALTER COLUMN id SET DEFAULT nextval('pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY qa_faqs ALTER COLUMN id SET DEFAULT nextval('qa_faqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY qa_files ALTER COLUMN id SET DEFAULT nextval('qa_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY question_assignments ALTER COLUMN id SET DEFAULT nextval('question_assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY recharge_codes ALTER COLUMN id SET DEFAULT nextval('recharge_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY recharge_records ALTER COLUMN id SET DEFAULT nextval('recharge_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY register_codes ALTER COLUMN id SET DEFAULT nextval('register_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY replies ALTER COLUMN id SET DEFAULT nextval('replies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY review_records ALTER COLUMN id SET DEFAULT nextval('review_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY schools ALTER COLUMN id SET DEFAULT nextval('schools_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY solutions ALTER COLUMN id SET DEFAULT nextval('solutions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY teaching_programs ALTER COLUMN id SET DEFAULT nextval('teaching_programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY teaching_videos ALTER COLUMN id SET DEFAULT nextval('teaching_videos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY videos ALTER COLUMN id SET DEFAULT nextval('videos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: qatime
--

ALTER TABLE ONLY vip_classes ALTER COLUMN id SET DEFAULT nextval('vip_classes_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY accounts (id, money, created_at, updated_at, user_id) FROM stdin;
26	0	2015-10-09 21:35:31.183449	2015-10-09 21:35:31.183449	3
27	0	2015-10-09 21:35:31.189865	2015-10-09 21:35:31.189865	22
28	0	2015-10-09 21:35:31.195125	2015-10-09 21:35:31.195125	5
29	0	2015-10-09 21:35:31.200677	2015-10-09 21:35:31.200677	14
30	0	2015-10-09 21:35:31.206812	2015-10-09 21:35:31.206812	15
31	0	2015-10-09 21:35:31.212382	2015-10-09 21:35:31.212382	4
32	0	2015-10-09 21:35:31.217916	2015-10-09 21:35:31.217916	54
33	0	2015-10-09 21:35:31.22317	2015-10-09 21:35:31.22317	37
34	0	2015-10-09 21:35:31.228428	2015-10-09 21:35:31.228428	33
35	0	2015-10-09 21:35:31.235237	2015-10-09 21:35:31.235237	31
36	0	2015-10-09 21:35:31.249136	2015-10-09 21:35:31.249136	16
37	0	2015-10-09 21:35:31.254374	2015-10-09 21:35:31.254374	17
38	0	2015-10-09 21:35:31.259871	2015-10-09 21:35:31.259871	19
39	0	2015-10-09 21:35:31.265166	2015-10-09 21:35:31.265166	18
40	0	2015-10-09 21:35:31.270574	2015-10-09 21:35:31.270574	27
41	0	2015-10-09 21:35:31.275523	2015-10-09 21:35:31.275523	23
42	0	2015-10-09 21:35:31.280825	2015-10-09 21:35:31.280825	30
43	0	2015-10-09 21:35:31.286188	2015-10-09 21:35:31.286188	34
44	0	2015-10-09 21:35:31.291606	2015-10-09 21:35:31.291606	52
45	0	2015-10-09 21:35:31.296925	2015-10-09 21:35:31.296925	55
46	0	2015-10-09 21:35:31.302066	2015-10-09 21:35:31.302066	51
47	0	2015-10-09 21:35:31.307368	2015-10-09 21:35:31.307368	45
48	0	2015-10-09 21:35:31.312367	2015-10-09 21:35:31.312367	43
49	0	2015-10-09 21:35:31.317812	2015-10-09 21:35:31.317812	44
50	0	2015-10-09 21:35:31.322936	2015-10-09 21:35:31.322936	9
51	0	2015-10-09 21:35:31.328599	2015-10-09 21:35:31.328599	11
52	0	2015-10-09 21:35:31.334904	2015-10-09 21:35:31.334904	48
53	0	2015-10-09 21:35:31.340098	2015-10-09 21:35:31.340098	53
54	0	2015-10-09 21:35:31.345866	2015-10-09 21:35:31.345866	56
55	0	2015-10-09 21:35:31.351608	2015-10-09 21:35:31.351608	49
56	0	2015-10-09 21:35:31.357381	2015-10-09 21:35:31.357381	46
57	0	2015-10-09 21:35:31.36278	2015-10-09 21:35:31.36278	20
58	0	2015-10-09 21:35:31.367849	2015-10-09 21:35:31.367849	28
59	0	2015-10-09 21:35:31.372922	2015-10-09 21:35:31.372922	36
60	0	2015-10-09 21:35:31.378585	2015-10-09 21:35:31.378585	35
61	0	2015-10-09 21:35:31.383839	2015-10-09 21:35:31.383839	39
62	0	2015-10-09 21:35:31.389377	2015-10-09 21:35:31.389377	40
63	0	2015-10-09 21:35:31.394842	2015-10-09 21:35:31.394842	38
64	0	2015-10-09 21:35:31.400407	2015-10-09 21:35:31.400407	6
65	0	2015-10-09 21:35:31.405548	2015-10-09 21:35:31.405548	24
66	0	2015-10-09 21:35:31.410909	2015-10-09 21:35:31.410909	42
67	0	2015-10-09 21:35:31.416796	2015-10-09 21:35:31.416796	63
68	0	2015-10-09 21:35:31.422794	2015-10-09 21:35:31.422794	32
69	0	2015-10-09 21:35:31.4279	2015-10-09 21:35:31.4279	21
70	0	2015-10-09 21:35:31.432921	2015-10-09 21:35:31.432921	29
71	0	2015-10-09 21:35:31.437828	2015-10-09 21:35:31.437828	62
72	0	2015-10-09 21:35:31.444221	2015-10-09 21:35:31.444221	50
73	0	2015-10-09 21:35:31.449922	2015-10-09 21:35:31.449922	59
74	0	2015-10-09 21:35:31.454825	2015-10-09 21:35:31.454825	60
75	0	2015-10-09 21:35:31.459969	2015-10-09 21:35:31.459969	26
76	0	2015-10-09 21:35:31.464915	2015-10-09 21:35:31.464915	61
77	0	2015-10-09 21:35:31.470725	2015-10-09 21:35:31.470725	65
78	0	2015-10-09 21:35:31.475685	2015-10-09 21:35:31.475685	70
79	0	2015-10-09 21:35:31.481296	2015-10-09 21:35:31.481296	68
80	0	2015-10-09 21:35:31.487179	2015-10-09 21:35:31.487179	8
81	0	2015-10-09 21:35:31.492573	2015-10-09 21:35:31.492573	12
82	0	2015-10-09 21:35:31.498838	2015-10-09 21:35:31.498838	72
83	0	2015-10-09 21:35:31.504596	2015-10-09 21:35:31.504596	73
84	0	2015-10-09 21:35:31.509841	2015-10-09 21:35:31.509841	7
85	0	2015-10-09 21:35:31.514788	2015-10-09 21:35:31.514788	74
87	1	2015-10-09 21:35:31.524915	2015-10-09 23:20:57.107639	2
86	-26.8299999999999983	2015-10-09 21:35:31.519896	2015-10-25 02:29:17.106781	75
88	2.52000000000000002	2015-10-10 13:31:39.977002	2015-10-25 02:29:17.130535	76
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('accounts_id_seq', 88, true);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY answers (id, question_id, teacher_id, token, content, created_at, updated_at, comments_count) FROM stdin;
1	1	26	2X15hPJn7554-Myhr_dSVA	<p><br><iframe frameborder="0" src="//www.qatime.cn/teaching_videos/4" width="640" height="360"></iframe></p>	2015-04-13 13:20:03.6485	2015-04-13 13:20:03.6485	0
2	1	26	2X15hPJn7554-Myhr_dSVA	<p><br><iframe frameborder="0" src="//www.qatime.cn/teaching_videos/5" width="640" height="360"></iframe></p>	2015-04-13 13:22:28.811598	2015-04-13 13:22:28.811598	0
3	1	26	2X15hPJn7554-Myhr_dSVA	<p><br><iframe frameborder="0" src="//www.qatime.cn/teaching_videos/6" width="640" height="360"></iframe></p>	2015-04-13 13:23:10.661715	2015-04-13 13:23:10.661715	0
4	2	65	VA8lxqchOT-t5ZZHkWwD3Q	<p><br><iframe frameborder="0" src="//localhost:3000/teaching_videos/7" width="640" height="360"></iframe></p><p>asdfasdfasdfasdfad</p>	2015-04-14 11:52:43.61857	2015-04-14 11:52:43.61857	0
6	2	65	VA8lxqchOT-t5ZZHkWwD3Q	<p><br><iframe frameborder="0" src="//localhost:3000/teaching_videos/8" width="640" height="360"></iframe>&nbsp;</p><p><br></p>	2015-04-18 23:24:08.970805	2015-04-18 23:24:08.970805	0
7	2	65	VA8lxqchOT-t5ZZHkWwD3Q	<p><br><iframe frameborder="0" src="//localhost:3000/teaching_videos/9" width="640" height="360"></iframe></p>	2015-04-19 00:21:39.747521	2015-04-19 00:21:39.747521	0
17	22	2	1440646892-ADosWGP01djT1Jds8gDn6A	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/70f7a7e5af991f957158dd4853b83b4e.png"></p>	2015-08-27 03:42:09.366539	2015-08-27 03:42:09.366539	0
18	22	2	1440653689-OyKOkuPa-gKtFRKTrFi9VA	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/304b01984cd9f0f0bbb039ddde0487fe.png"></p>	2015-08-27 05:35:14.432698	2015-08-27 05:35:14.432698	0
19	22	2	1440655628-LuqaKi7mEkmMHnyKuwNH7Q	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/b60c48eaef35b45ba5a75bf6e0ffff0f.png"></p>	2015-08-27 06:07:34.209002	2015-08-27 06:07:34.209002	0
20	22	2	1440655671-kQ5mkOspZCdqLdJvdfG2ag	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/eabccd6a26a8a7b29c6be15889890995.png"></p>	2015-08-27 06:08:16.83019	2015-08-27 06:08:16.83019	0
21	22	2	1440655852-ZaLhc_MrOd-2qDNuABfTyA	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/6763a38925fbcf76b4acbf6091fbdbf8.png"></p>	2015-08-27 06:11:20.463297	2015-08-27 06:11:20.463297	0
22	22	2	1440655910-wlQur7z-nn6Vd2wM8YnBYQ	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/31d4722355a0258aa8262fc71c52834d.png" style="width: 759px;"></p>	2015-08-27 06:12:10.644155	2015-08-27 06:12:10.644155	0
23	22	2	1440655999-d2DDowtINX9fwJ02wS_K1A	<p><br><img style="width: 759px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/e5fa0b03b3faea9ac9bf9cc22ec2def4.png"></p><p><br></p><p><br><img style="width: 806px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/fa471b1fa451294bac0802086f5fb120.jpg"></p>	2015-08-27 06:13:34.701018	2015-08-27 06:14:19.986979	0
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('answers_id_seq', 23, true);


--
-- Data for Name: cash_operation_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY cash_operation_records (id, operator_id, account_id, value, type, created_at, updated_at) FROM stdin;
1	57	87	10	Deposit	2015-10-09 21:42:19.448951	2015-10-09 21:42:19.448951
2	57	87	2	Withdraw	2015-10-09 21:43:10.141909	2015-10-09 21:43:10.141909
3	57	87	5	Withdraw	2015-10-09 21:43:36.993067	2015-10-09 21:43:36.993067
4	57	87	1	Withdraw	2015-10-09 21:44:12.053671	2015-10-09 21:44:12.053671
5	58	87	1	Withdraw	2015-10-09 23:20:57.094861	2015-10-09 23:20:57.094861
6	58	86	20	Deposit	2015-10-09 23:22:08.194662	2015-10-09 23:22:08.194662
\.


--
-- Name: cash_operation_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('cash_operation_records_id_seq', 6, true);


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY cities (id, name, created_at, updated_at) FROM stdin;
1	阳泉	2014-06-25 12:19:30.248859	2014-06-25 12:19:30.248859
\.


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('cities_id_seq', 2, false);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY comments (id, content, author_id, commentable_id, commentable_type, created_at, updated_at) FROM stdin;
67	kkkkk	75	1	Correction	2015-09-18 09:19:30.320835	2015-09-18 09:19:30.320835
69	asdfasdf看看啊	75	5	Solution	2015-09-18 09:45:38.558048	2015-09-18 09:46:27.018705
70	看看啊	75	1	Correction	2015-09-18 09:46:44.189326	2015-09-18 09:46:44.189326
71	感觉不错的说	75	6	Correction	2015-09-18 09:46:56.530876	2015-09-18 09:46:56.530876
72	看看别人怎么说	75	3	Correction	2015-09-18 09:47:06.64844	2015-09-18 09:47:06.64844
73	u	2	1	Correction	2015-09-18 09:47:18.860418	2015-09-18 09:47:18.860418
74	啊啊啊啥地方	75	9	Correction	2015-09-18 09:49:57.496518	2015-09-18 09:49:57.496518
60	asdfas俩理疗	75	24	Question	2015-09-18 07:56:37.543222	2015-09-18 07:57:03.024816
62	aa\r\n	75	24	Question	2015-09-18 08:06:43.172528	2015-09-18 08:06:43.172528
64	看样子不错啊	75	5	Solution	2015-09-18 08:15:55.086014	2015-09-18 08:15:55.086014
75	做的不错	57	11	Solution	2015-10-04 03:41:39.92496	2015-10-04 03:41:39.92496
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('comments_id_seq', 75, true);


--
-- Data for Name: consumption_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY consumption_records (id, fee_id, account_id, value, created_at, updated_at) FROM stdin;
1	1	86	10.9199999999999999	2015-10-10 13:42:24.221435	2015-10-10 13:42:24.221435
2	2	86	10.9199999999999999	2015-10-10 14:19:05.730647	2015-10-10 14:19:05.730647
3	3	86	10.9199999999999999	2015-10-10 14:19:05.906271	2015-10-10 14:19:05.906271
4	4	86	10.9199999999999999	2015-10-10 14:19:06.109579	2015-10-10 14:19:06.109579
5	5	86	0.630000000000000004	2015-10-18 01:14:52.255912	2015-10-18 01:14:52.255912
6	6	86	0.630000000000000004	2015-10-18 01:22:32.857194	2015-10-18 01:22:32.857194
7	7	86	0.630000000000000004	2015-10-18 01:58:11.26416	2015-10-18 01:58:11.26416
8	8	86	0.630000000000000004	2015-10-25 00:18:18.239878	2015-10-25 00:18:18.239878
9	9	86	0.630000000000000004	2015-10-25 02:29:17.101473	2015-10-25 02:29:17.101473
\.


--
-- Name: consumption_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('consumption_records_id_seq', 9, true);


--
-- Data for Name: corrections; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY corrections (id, content, teacher_id, solution_id, token, created_at, updated_at, comments_count, customized_course_id, homework_id, status, type, customized_tutorial_id, examination_id) FROM stdin;
10	看看不错	2	6	1443326612-aurMM2OTx5YMJq8SQd8Myg	2015-09-27 04:03:45.093425	2015-10-06 08:48:07.768799	0	2	8	false	\N	\N	\N
11	okok13413	2	8	1443695905-JCvEW1FbZe0Y6rRwwHEYEw	2015-10-01 10:38:34.214857	2015-10-06 08:48:08.002553	0	2	9	false	\N	\N	\N
12	测试批改作业	2	10	1443846134-eroA5JjNEgdIQ9aMVAk0aQ	2015-10-03 04:22:26.285683	2015-10-06 08:48:08.043992	0	2	9	false	\N	\N	\N
2	\N	2	5	1442555694-c0mEvocVv1PZEltseApbFw	2015-09-18 05:54:54.595859	2015-10-07 14:03:41.750269	0	\N	5	false	\N	\N	\N
4	\N	2	5	1442555936-l2rdrO9-jwafIoLCe7mASQ	2015-09-18 05:58:56.905999	2015-10-07 14:03:41.905636	0	\N	5	false	\N	\N	\N
5	asdfasdf	2	5	1442555936-x-sSQahmIQZMaKXrdLxc4w	2015-09-18 05:59:29.143379	2015-10-07 14:03:41.926148	0	\N	5	false	\N	\N	\N
7	<p><span style="background-color: rgb(247, 198, 206);">asdfa</span></p><p><span style="background-color: rgb(247, 198, 206);"><br></span></p><h1><span style="background-color: rgb(247, 198, 206);">asasdfasf</span></h1>	2	5	1442559887-6sgZ1ej5pShMqNyII5QeDA	2015-09-18 07:05:19.73003	2015-10-07 14:03:41.958465	0	\N	5	false	\N	\N	\N
8	<h1>asdfasdf</h1>	2	5	1442561022-bRqfnrBZygSi9Qwq2JbQeA	2015-09-18 07:25:48.393573	2015-10-07 14:03:41.988057	0	\N	5	false	\N	\N	\N
6	okokokokoasdfasdf	2	5	1442559866-WZwpNtk8P7O_lZWnApRLFg	2015-09-18 07:04:47.073748	2015-10-07 14:03:42.029798	1	\N	5	false	\N	\N	\N
3	\N	2	5	1442555713-f7cAZMDahJzPR6dfcewztw	2015-09-18 05:55:13.704144	2015-10-07 14:03:42.07022	1	\N	5	false	\N	\N	\N
1	\N	2	5	1442554973-YCBedF6kxFk2Q_9UiM9gxA	2015-09-18 05:42:53.760921	2015-10-07 14:03:42.105689	3	\N	5	false	\N	\N	\N
9	<h1>asdfasdf</h1><h1><br></h1><h1>kany烟仔不错</h1>	2	5	1442561148-NvhoyuxzJ3R_3_Whx7Y7ZQ	2015-09-18 07:32:44.634723	2015-10-07 14:03:42.130074	1	\N	5	false	\N	\N	\N
13	asdfasdfasfasdfasdfas	2	11	1444224404--Qa14L3Az-V9gghacUrg5A	2015-10-07 13:26:56.796116	2015-10-07 14:03:42.172133	0	2	9	false	\N	\N	\N
14	kankankan	2	11	1444224478-gD9zCDrKGGHb76WZpHF33Q	2015-10-07 13:28:06.229262	2015-10-07 14:03:42.196594	0	2	9	false	\N	\N	\N
15	asdfadfadsfa	2	11	1444224486-84Ulw1qtqhbOXeJePk6UKA	2015-10-07 13:30:43.150865	2015-10-07 14:03:42.2366	0	2	9	false	\N	\N	\N
17	asdfasdf	76	13	1445293036-s5t6Ay3bZfLLAXTrRrR7Hw	2015-10-19 22:17:24.805733	2015-10-19 22:17:24.805733	0	3	18	open	\N	\N	\N
18	asdfasfd	76	16	1445553051-khfH6_v_ps6NcYv0sZ2uOQ	2015-10-22 22:50:57.847266	2015-10-22 22:50:57.847266	0	3	\N	open	HomeworkCorrection	\N	\N
20		76	16	1445554387-uGvAcmBYNPURl15LWZTmpQ	2015-10-22 22:53:52.88351	2015-10-22 22:53:52.88351	0	3	\N	open	HomeworkCorrection	\N	\N
21	asdfasdf	76	16	1445557041-cN0yElCq8JdDnizSHI7USw	2015-10-22 23:37:43.617924	2015-10-22 23:37:43.617924	0	3	\N	open	HomeworkCorrection	\N	\N
19	``````adddd++sdfasfasdfasdfasdfaaaadddd	76	16	1445554347-YXOdd9SRmd9PSBUxVPmtGw	2015-10-22 22:53:07.140889	2015-10-23 07:52:54.071502	0	3	\N	open	HomeworkCorrection	\N	\N
22	++++adfasdfasfasdfsf	76	20	1445586815-V2LRQr48h6zzgtuijKbGQA	2015-10-23 07:53:56.246321	2015-10-23 07:56:46.866577	0	3	\N	open	ExerciseCorrection	15	\N
23	kkkkkk	76	20	1445587407-V3dl3pEEdRghG10-SF_rwg	2015-10-23 08:03:35.174069	2015-10-23 08:03:35.174069	0	3	\N	open	ExerciseCorrection	15	\N
24	lkjljlkmlkmkl	76	20	1445587415-uLyKrpLzzj3NAXeOBVZqXQ	2015-10-23 08:07:28.057999	2015-10-23 08:07:28.057999	0	3	\N	open	ExerciseCorrection	15	\N
25	lkmlm;lm;lk	76	20	1445587648-d3BZZQtXD40ppyjGvGxEQw	2015-10-23 08:08:15.114243	2015-10-23 08:08:15.114243	0	3	\N	open	ExerciseCorrection	15	\N
26	;l;lk;lk;lk;	76	20	1445587695-vcZKqe4Plu-YuxUI8_AhGA	2015-10-23 08:10:43.720815	2015-10-23 08:10:43.720815	0	3	\N	open	ExerciseCorrection	15	\N
27	asdfasdfasdfasdfadsf	76	20	1445587843-lmxw7PLEDZu9mRag2AUI3Q	2015-10-23 08:19:23.733765	2015-10-23 08:19:23.733765	0	3	\N	open	ExerciseCorrection	15	20
28	ccccdddd	76	17	1445588551-ql6ea-2uljQDSCf2r4hDBA	2015-10-23 08:22:50.830576	2015-10-23 08:22:50.830576	0	3	\N	open	HomeworkCorrection	\N	22
29	qefqwefqwefqwf	76	17	1445729570-iO3PqyCeYYR1gJyJEmAOjw	2015-10-24 23:33:07.137706	2015-10-24 23:33:07.137706	0	3	\N	open	HomeworkCorrection	\N	22
30	asdfasdfadfasdfadf	76	22	1445731798-9gPdlRu84xeQZ3VMiaoc9Q	2015-10-25 00:10:16.840178	2015-10-25 00:18:18.294944	0	3	\N	closed	ExerciseCorrection	15	19
31	测试学生页面	76	17	1445737476-fjhDwD0WjHr4djHfo2z2_Q	2015-10-25 01:45:09.342473	2015-10-25 02:29:17.137744	0	3	\N	closed	HomeworkCorrection	\N	22
\.


--
-- Name: corrections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('corrections_id_seq', 31, true);


--
-- Data for Name: course_purchase_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY course_purchase_records (id, student_id, course_id, created_at, updated_at) FROM stdin;
1	3	1	2014-06-25 12:42:51.385341	2014-06-25 12:42:51.385341
\.


--
-- Name: course_purchase_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('course_purchase_records_id_seq', 2, false);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY courses (id, name, "desc", lessons_count, token, created_at, updated_at, price, teacher_id, state, course_purchase_records_count, curriculum_id, chapter, "position", delete_topics_count) FROM stdin;
1	示例课程一：力学的基本原理	第一课：力学的基本原理。力学是物理的基础知识点，需要用到很多基础知识。而且是后面很多重要知识点的基础，一定要好好学习。	1	\N	2014-06-25 12:26:39.852964	2014-06-25 12:41:29.70621	30	2	published	1	\N	\N	0	0
3	NNNNNN	DWFEFERFWERFWERFWERFWERFWEFRWERFEFQWEFQFQWE	2	\N	2014-06-27 07:08:57.858669	2014-06-27 07:08:57.858669	10	2	unpublished	\N	\N	\N	0	0
4	44444444	123E123E123E2E12E12E312E12E13E1123QXSAasasassaas	2	\N	2014-06-27 07:30:27.095375	2014-06-27 07:30:27.095375	10	2	unpublished	\N	\N	\N	0	0
5	uuuuuuuuu	uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu	1	\N	2014-06-27 07:41:29.293294	2014-06-27 07:41:29.293294	10	2	unpublished	\N	\N	\N	0	0
6	牛顿定理	去玩儿去玩儿去玩儿去玩儿1341234123412412341234124121234123412341	2	\N	2014-06-27 08:28:07.263934	2014-06-27 08:28:07.263934	10	2	unpublished	\N	\N	\N	0	0
7	对数函数的单调性（一 )	12341241234qwerqwerqwerwqerqwerqwrwqersgfasfsdfdsaf	1	\N	2014-06-27 08:40:34.371677	2014-06-27 08:40:34.371677	10	2	unpublished	\N	\N	\N	0	0
8	牛顿第二定律	1234123412412123412341241212341234124121234123412412123412341241212341234124121234123412412	2	\N	2014-06-27 10:06:37.238302	2014-06-27 10:06:37.238302	10	2	unpublished	\N	\N	\N	0	0
9	niudui	每个知识点都是一段视频。每段视频不要超过5分钟。 一个课程 所谓知识点要以"干"货为主，解决学生在解题考试中最容易遇到的问题， 易错点的分析、习题课、试卷讲解、等等。知识点的创建是在课程创建之后进行的。\r\n课程状态 这个选项是控制是否把课程开放给学生。 课程一开始创建的时候是没有知识点的（但是已经有价格了），如果直接开放给学生学生看不到任何知识点，会引起误解， 所以这个时候建议把课程状态	1	\N	2014-06-28 00:52:05.262121	2014-06-28 00:52:05.262121	10	2	unpublished	\N	\N	\N	0	0
10	yyyyjjjj	、试卷讲解、等等。知识点的创建是在课程创建、试卷讲解、等等。知识点的创建是在课程创建	0	\N	2014-06-28 01:07:02.724304	2014-06-28 01:07:02.724304	10	2	unpublished	\N	\N	\N	0	0
11	oooooo	包含若干知识点，每个知识点都是一段视频。每段视频不要超过5分钟。 一个课程 所谓知识点要以"干"货为主，解决学生在解题考试中最容易遇到的问题， 易错点的分析、习题课、试卷讲解、	0	\N	2014-06-28 07:19:08.305883	2014-06-28 07:19:08.305883	10	2	unpublished	\N	\N	\N	0	0
2	牛顿定律	牛顿定律，牛顿定律，牛顿定律，牛顿定律，牛顿定律，牛顿定律，牛顿定律	2	\N	2014-06-27 05:28:59.712766	2014-06-27 05:28:59.712766	10	2	unpublished	\N	\N	\N	0	0
24	第三讲  速度重点提示	1、速度的分类\r\n2、日常说法和教材概念的区别\r\n3、解题时如何正确理解题中的速度含义\r\n	1	\N	2014-10-28 14:31:16.103397	2015-04-09 23:06:39.018376	10	7	unpublished	\N	2	运动的描述	0	0
16	123	111111111114444444444444444444	1	\N	2014-09-29 08:45:19.668777	2015-04-09 23:06:39.041477	10	20	unpublished	\N	93	集合	0	0
17	7777777777777777	4555555555555555555555555555555555555555555555555555555555555555555555551111111111111111111111111111111111111	0	\N	2014-09-29 09:07:52.772018	2015-04-09 23:06:39.050892	10	20	unpublished	\N	93	集合	0	0
26	412	tjrsxjtuihgluyrykdsjtjstjrtdtjrdrtjduy7li8oij	0	\N	2014-10-30 10:00:15.897979	2015-04-09 23:06:39.058911	10	20	unpublished	\N	93	集合	0	0
22	函数解析式的求法	函数解析式的求法简洁——待定系数、配凑法、换元法、方程组法等等。	0	\N	2014-10-22 11:41:28.018922	2015-04-09 23:06:39.066459	10	24	unpublished	\N	141	基本初等函数	0	0
23	变力做功的处理方法	学生们在学习功的时候，由于不能正确的理解功的定义，所以在碰到变力做功的问题时，经常感到无从下手这一节内容主要介绍了几种变力做功的处理方法。	1	\N	2014-10-23 04:45:03.358796	2015-04-09 23:06:39.076517	10	26	unpublished	\N	162	机械能及其守恒定律	0	0
21	机械能守恒定律的误区	这节课主要归纳了学生们在学习机械能守恒定律时不能正确理解机械能守恒的条件而导致在使用的过程中出现的一些错误的判断和分析，主要包括五个方面的内容。	1	\N	2014-10-22 11:37:02.419884	2015-04-09 23:06:39.08596	10	26	published	\N	162	机械能及其守恒定律	0	0
20	第二讲 科学设计坐标系的最小长度和单位	科学设计坐标系的最小长度和单位：标度设计的要求是：既不能太大也不能太小。太大了纸放不下，太小了误差大，又不美观。 \r\n	1	\N	2014-10-19 05:19:34.5922	2015-04-09 23:06:39.093805	10	7	unpublished	\N	2	运动的描述	0	0
27	2	nnnnnnnnnnnnnnnnnnnn3423rergdthbcnhjgfbcdvbd,./v,/,?,/,/,/,/,/,/,/,/,/,/,/,/	1	\N	2014-10-31 09:16:47.682176	2015-04-09 23:06:39.101652	10	20	unpublished	\N	93	集合	0	0
25	真核生物和原核生物的区别	本课程讲述了原核生物和真核生物在各方面的区别，以及区分原核生物和真核生物的方法。	1	\N	2014-10-30 00:21:42.787227	2015-04-09 23:06:39.130002	10	30	unpublished	\N	188	走近细胞	0	0
14	第一讲 质点、参考系和坐标系	重点内容回顾：1、为什么要引入质点？   2、物体能否视为质点的原则？   3、对参考系的理解。	1	\N	2014-09-01 15:37:20.921636	2015-04-09 23:06:39.138779	10	7	unpublished	\N	2	运动的描述	0	0
39	电势	这节内容主要通过例题来介绍电势高低的判定方法。一、通过电势定义判定。二、通过电势差定义判定。三、通过电场线判定。四、通过做功来判定。	3	\N	2014-11-11 12:54:23.476615	2015-04-09 23:06:39.211154	10	26	published	\N	163	静电场	0	0
40	电势能	这节内容主要通过例题来介绍电势高低的判定方法。一、通过电势定义判定。二、通过电势差定义判定。三、通过电场线判定。四、通过做功来判定。	0	\N	2014-11-11 12:54:45.071197	2015-04-09 23:06:39.220585	10	26	unpublished	\N	163	静电场	0	0
34	第四讲 ：关于“用打点计时器测速度”实验的几点说明\v	1、电磁打点计时器、电火花计时器的作用：  答：记录时间和位移。\r\n2、电磁打点计时器、电火花计时器的异同：答：相同点：都使用交流电；\r\n       不同点: 电磁打点计时器需要接在学生电源上的4—6伏交流电，电火花计时器可直接接在日常电源插座上，使用220伏的交流电	0	\N	2014-11-03 04:41:53.374001	2015-04-09 23:06:39.227899	10	7	unpublished	\N	2	运动的描述	0	0
35	第四讲 ：关于“用打点计时器测速度”实验的几点说明\v	1、电磁打点计时器、电火花计时器的作用：  答：记录时间和位移。\r\n2、电磁打点计时器、电火花计时器的异同：答：相同点：都使用交流电；\r\n       不同点: 电磁打点计时器需要接在学生电源上的4—6伏交流电，电火花计时器可直接接在日常电源插座上，使用220伏的交流电	1	\N	2014-11-03 04:42:03.313336	2015-04-09 23:06:39.235058	10	7	unpublished	\N	2	运动的描述	0	0
13	运动的基本概念	运动的基本概念讲述了什么是运动，运动在我们生活中体现在哪些方面，都有哪些常见的运动。	6	\N	2014-08-07 14:25:17.212875	2015-05-31 22:30:46.288935	10	2	unpublished	\N	1	运动的描述	0	0
80	这里的小节不需要和课本中小节一一对应	这是一个用作示例的小节，用于展示和测试，这个地方最好写的详细一点。	3	\N	2015-04-22 23:12:06.407428	2015-04-22 23:12:06.407428	30	2	unpublished	\N	323	静电场	1	2
43	第六讲 加速度（二）	8、趣味理解加速度与速度的关系\r\n（1）  加速度增加的加速运动：就好比每天往银行存款的数目增加，第一天存10元、第二天存20元、第三天存30元……，银行账户的总额当然会增加。\r\n	1	\N	2014-11-16 02:48:56.197242	2015-04-09 23:06:39.243048	10	7	unpublished	\N	2	运动的描述	0	0
42	胡萝卜素的提取	本课题要求了解胡萝卜素的基础知识和提取原理；学会提取胡萝卜素的技术和纸层析的操作要求。\r\n	1	\N	2014-11-13 04:35:32.076352	2015-04-09 23:06:39.253192	10	33	published	\N	215	植物有效成分的提取	0	0
52	法拉第电磁感应定律的应用	法拉第电磁感应定律，是高中物理的难度和重点。尤其是综合应用楞次定律和法拉第电磁感应定律分析问题	0	\N	2015-01-01 07:39:38.661365	2015-04-09 23:06:39.261918	10	21	unpublished	\N	116	电磁感应	0	0
45	第七讲 x-t图像、v-t图像的识读技巧	在高中物理中有许多图像，同学们感到很头疼或负担重。其实物理图像的出现，不是为了学图像而学图像，即额外增加同学们的负担，而是为了帮助同学们将抽象的物理问题形象化，是用数学方法----图像法处理物理问题的一种方法或手段。同学们不仅要学会识图，更要学会应用。这样不仅会帮助同学们正确理解题意，而且会使解题更加简单快捷，希望同学们重视并灵活地掌握这种方法---图像法。\r\n	1	\N	2014-11-29 13:58:55.304152	2015-04-09 23:06:39.26929	10	7	unpublished	\N	2	匀变速直线运动	0	0
44	第七讲v-t图像和x-t图像的识读技巧	         在高中物理中有许多图像，同学们感到很头疼或负担重。其实物理图像的出现，不是为了学图像而学图像，即额外增加同学们的负担，而是为了帮助同学们将抽象的物理问题形象化，是用数学方法----图像法处理物理问题的一种方法或手段。	0	\N	2014-11-26 15:09:27.713324	2015-04-09 23:06:39.276316	10	7	unpublished	\N	2	运动的描述	0	0
46	降低化学反应的活化能的酶实验部分	降低化学反应的活化能的酶实验部分，本节主要是对基础核心知识梳理以及教材变式	1	\N	2014-12-14 23:52:54.348274	2015-04-09 23:06:39.283363	10	33	published	\N	212	细胞的能量供应和利用	0	0
47	果酒果醋的制作	果酒果醋的制作，知识梳理典题突破，主要是通过学习能对要点有所掌握	1	\N	2014-12-14 23:58:16.789226	2015-04-09 23:06:39.290822	10	33	unpublished	\N	215	传统发酵技术的应用	0	0
48	腐乳的制作	腐乳的制作，知识梳理、思维拓展、典例分析本节小结，通过学习能梳理知识达到知识的内化	1	\N	2014-12-15 00:19:08.997289	2015-04-09 23:06:39.298142	10	33	unpublished	\N	215	传统发酵技术的应用	0	0
49	 第八讲 第二章   解题归类（一）	要养成画物体运动示意图或v－t图象\r\n的习惯，特别是较复杂的运动，画出示意图或v－t图象可使运动过程直观，物理过程清晰，便于分析研究．\r\n	1	\N	2014-12-29 01:29:54.980689	2015-04-09 23:06:39.308157	10	7	unpublished	\N	2	匀变速直线运动	0	0
50	wuli	包含若干知识点，每个知识点，每个知识点都是一段视频。每段视频不要超过5分钟。 一个课程 所谓知识点要以"干"货为主，解决学生在解题考试中最容易遇到的问题， 易错点的分析、习题课、试卷讲解、等等。知识点的创建是在课程创建之后进行的。	0	\N	2015-01-01 07:12:23.197771	2015-04-09 23:06:39.318009	10	21	unpublished	\N	113	运动的描述	0	0
51	法拉第电磁感应定律的应用	法拉第电磁感应定律，是高中物理的难度和重点。尤其是综合应用楞次定律和法拉第电磁感应定律分析问题	0	\N	2015-01-01 07:39:24.833282	2015-04-09 23:06:39.327783	10	21	unpublished	\N	116	电磁感应	0	0
53	用等势点来简化电路	电路的化简有各种各样的方法。这部分内容主要通过一个例题简绍了用等势线简化电路的方法。	1	\N	2015-01-12 14:22:18.97083	2015-04-09 23:06:39.336956	10	26	published	\N	163	恒定电流	0	0
54	用纸带分析物体的运动	   用纸带分析物体的运动，从而可以求得物体的速度和加速度。\r\n  纸带问题一直是高中物理知识的重点和难点。	1	\N	2015-01-13 08:28:58.761623	2015-04-09 23:06:39.346156	10	21	unpublished	\N	113	运动的描述	0	0
58	第十二讲  专题一  如何巧解追击和相遇问题（三）	      慢匀A在后，快减B在前。这种情况分两个阶段，阶段一：A、B共速之前，已慢A为参考系，快B远离A,二者间距在扩大；阶段二：AB共速之后，因为B减速，所以A速大于B速，以B为参考系，AB间距在缩短，所以AB共速时二者间距最大	1	\N	2015-02-27 13:59:13.120106	2015-04-09 23:06:39.353357	10	7	unpublished	\N	2	匀变速直线运动	0	0
55	第九讲  第二章   解题归类（二）	由于运动学部分的公式较多，并且各公式之间又相互联系，所以本章中的一些题目常可一题多解．因此在解题时要思路开阔，联想比较，筛选出最为便捷的解题方案，从而简化解题过程．本章的常用解题方法及规律特点见下表：\r\n	1	\N	2015-01-15 05:22:32.708915	2015-04-09 23:06:39.360428	10	7	unpublished	\N	2	匀变速直线运动	0	0
38	第五讲  加速度（一）	加速度是同学们进入高中以来，继位移之后的第二个全新的物理量。从好奇心的角度已经足够重视了，但要真正理解加速度概念还必须注意以下几点：\r\n	1	\N	2014-11-10 15:12:05.623162	2015-04-09 23:06:39.367222	10	7	unpublished	\N	2	运动的描述	0	0
56	第十讲 专题一  如何巧解追击和相遇问题（一）	追击和相遇问题是运动学不可回避的问题。问题很多，方法也不少，但追其本质，我找到了一种巧妙思维，可解决任何问题：那就是始终以慢速物体为参考系，所有问题都好理解、都好解决。	1	\N	2015-02-13 05:32:19.295357	2015-04-09 23:06:39.374555	10	7	unpublished	\N	2	匀变速直线运动	0	0
59	第十三讲  专题一   如何“巧”解\v          追击和相遇问题(四)	（二）同向、同时、同起点。这种情况主要解决相遇几次的的问题。\r\n	1	\N	2015-03-05 09:20:47.746429	2015-04-09 23:06:39.38873	10	7	unpublished	\N	2	匀变速直线运动	0	0
60	第十四讲  专题一   如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例	  如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例	0	\N	2015-03-11 16:21:23.233598	2015-04-09 23:06:39.403632	10	7	unpublished	\N	2	运动的描述	0	0
62	法拉弟电磁感应定律一	这节课主要从法拉弟电磁感应定律的定义式出发介绍了利用定义求感应电动势的三种方法	1	\N	2015-03-18 14:02:30.469229	2015-04-09 23:06:39.412981	10	26	published	\N	164	电磁感应	0	0
63	追击相遇问题	这节课主要介绍了追击相遇的关键问题和常见的两种追击相遇问题中极值的判定方法	7	\N	2015-03-21 12:18:21.394372	2015-04-09 23:06:39.421256	10	26	published	\N	161	匀变速直线运动	0	0
64	“边角互化”解决三角形问题	利用所学的正、余弦定理进行“边角互化”来解决一类三角形中的常见问题。	1	\N	2015-03-22 14:19:32.359744	2015-04-09 23:06:39.430096	10	24	unpublished	\N	145	解三角式	0	0
81	看到到底心不行	cececåçcececåçcececåçcececåçcececåç	0	\N	2015-05-28 10:29:00.442625	2015-05-28 10:38:48.8845	30	2	unpublished	\N	322	机械能及其守恒定律	1	0
65	第十五    讲皮带专题（一）-----如何求解物体在皮带上的运动时间	例1、   如图所示，长为L=6.25m的水平传送带以速度v1=5m/s匀速运动，质量均为m的小物体P、Q由通过定滑轮且不可伸长的轻绳相连，某时刻P在传送带左端具有向右的速度v2=8m/s，P与定滑轮间的绳水平，P与传送带间的动摩擦因数为μ=0.2，重力加速度g=10m/s2，不计定滑轮质量和摩擦，绳足够长。求：\r\n（1）P物体刚开始在传送带上运动的加速度大小;\r\n（2）P物体在传送带上运动的时间。\r\n	1	\N	2015-03-22 14:52:11.698406	2015-04-09 23:06:39.447024	10	7	unpublished	\N	2	牛顿运动定律	0	0
70	第十八讲  总结和扩充 小船过河模型的常用物理量	二、典例　小船在200 m宽的河口横渡，水流速度为3 m/s，船在静水中的航速是5 m/s，求：\r\n(1)当小船的船头始终正对对岸行驶时，它将在何时、何处到达对岸？\r\n(2)要使小船到达河的正对岸，应如何行驶？多长时间能到达对岸？(sin37°＝0.6)\r\n　 \r\n	1	\N	2015-04-03 15:10:44.759585	2015-04-09 23:06:39.457576	10	7	unpublished	\N	3	曲线运动	0	0
72	第十九讲  如何判断和求解平抛运动的抛出点的坐标	如何判断和求解平抛运动的抛出点的坐标是平抛运动的一个难点，同学们有一个固定思维，坐标原点永远和抛出点对应，其实不然..	1	\N	2015-04-06 10:15:49.694892	2015-04-09 23:06:39.467002	10	7	unpublished	\N	3	曲线运动	0	0
71	第十九讲 如何判断和求解平抛运动的抛出点的坐标	 如何判断和求解平抛运动的抛出点的坐标是平抛运动的一个难点，同学们有一个固定思维，坐标原点永远和抛出点对应，其实不然.........	0	\N	2015-04-06 10:10:55.942019	2015-04-09 23:06:39.476277	10	7	unpublished	\N	3	机械能及其守恒定律	0	0
66	v----t图象	这节课主要介绍了v----t图象的基本特点，斜率的意义，面积的意义等	8	\N	2015-03-23 04:12:47.107987	2015-04-09 23:06:39.485245	10	26	published	\N	161	匀变速直线运动	0	0
67	第十六讲   如何正确理解 和解答力的合成与分解问题	如 何 正 确 理 解 和 解 答 力的合成与分解问题\r\n       核心理念 -----力的合成与分解的本质：等效代换；在受力分析时：分力和合力没有施力物体。\r\n	1	\N	2015-03-24 04:57:02.276438	2015-04-09 23:06:39.492492	10	7	unpublished	\N	2	相互作用	0	0
68	第十七讲 皮带专题（二）-----如何求解物体在倾斜皮带上的运动时间	第十七讲 皮带专题（二）-----如何求解物体在倾斜皮带上的运动时间\r\n	1	\N	2015-03-29 13:48:58.175024	2015-04-09 23:06:39.49977	10	7	unpublished	\N	2	牛顿运动定律	0	0
37	ATP的主要来源------细胞呼吸	“细胞呼吸”是人教版高中课程标准实验教科书《生物1•分子与细胞》第五章第三节的内容。本节介绍了生物异化作用的一个重要过程，为学生了解不同生物生命活动的过程奠定了基础。它与前面所学的线粒体的结构和功能、主动运输、酶、ATP、光合作用等内容有密切的联系，也为今后学习其他生命活动及规律奠定基础。	1	\N	2014-11-10 09:22:38.527526	2015-04-09 23:06:39.17531	10	33	published	\N	212	细胞的能量供应和利用	0	0
41	种群的数量变化	“种群数量的变化”一节是新课程标准教材人教版生物必修3第四章第2节的内容。本节课可分为三部分：第一部分是建构种群增长模型的方法。正文结合“问题探讨”中的实例，引导学生分析建构数学模型的方法，并尝试进行模型形式的转换；第二部分是种群数量的变化情况，包括种群增长的“j”型曲线、种群增长的“s”型曲线、种群数量的波动和下降。教材以问题串的形式揭示了这四种情况之间的内在联系。第三部分是 “探究”——“培养液中酵母菌种群数量的变化”	1	\N	2014-11-13 04:23:41.204409	2015-04-09 23:06:39.182584	10	33	published	\N	214	种群和群落	0	0
57	第十一讲 专题一   如何“巧”解追击和相遇问题(二)	3、匀慢A在前，快减B在后。此情况也分两阶段：第一阶段、共速之前，以慢A为参考系，快B一直在靠近慢A；第二阶段：共速之后，由于B减速A匀速，所以B速小于A，改以B为参考系，A在远离B，所以二者共速时间距最小。若在共速之前B追不上A，以后就再也追不上了。所以，A、B恰好不撞的条件为二者相遇时恰好共速。\r\n	1	\N	2015-02-21 09:57:55.033404	2015-04-09 23:06:39.381686	10	7	unpublished	\N	2	匀变速直线运动	0	0
75	二次根式双重非负性	二次根式的两个公式的重要运用，中考中作为一个很重要的考点，重点在两个公式。	0	\N	2015-04-13 02:00:05.66323	2015-04-13 02:00:05.66323	30	63	unpublished	\N	299	二次根式	1	0
73	7.1力	学习力的概念及单位、符号，会判断力的作用效果，了解物体的运动状态的含义，知道影响力的作用效果的因素（三要素），会画力的示意图，会应用力的作用是相互的进行相关解题。	4	\N	2015-04-12 02:23:03.994007	2015-04-12 02:28:19.834472	30	59	unpublished	\N	282	力	1	0
76	7.2弹力	认识弹性、塑性；知道弹力包括什么；知道弹簧测力计的工作原理及构造；会使用弹簧测力计测量力的大小；会进行关于弹簧测力计的相关问题的解答。	0	\N	2015-04-13 13:02:24.670498	2015-04-13 13:02:24.670498	30	59	unpublished	\N	282	力	2	0
77	7.3重力	知道重力的概念，知道哪些物体受到重力作用；知道重力大小与质量的关系并会进行相关计算；知道重力的方向并能利用它解决一些实际问题；知道重力的作用点叫重心，并知道影响重心位置的因素；会确定物体重心的位置；会画重力的示意图。	0	\N	2015-04-13 13:04:42.980947	2015-04-13 13:04:42.980947	30	59	unpublished	\N	282	力	3	0
74	第二十讲  圆周运动专题（一）------求解圆周运动的 基 本 步 骤	一求解圆周运动问题的一般步骤：\r\n1、确定研究对象；2、确定研究对象所在的圆周运动的\r\n     平面----找圆心、确定半径；\r\n\r\n	1	\N	2015-04-12 15:33:02.269093	2015-04-13 07:31:21.815377	30	7	unpublished	\N	3	曲线运动	5	0
78	集合集合集合	集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合集合	1	\N	2015-04-15 08:30:48.32071	2015-04-15 08:30:48.32071	30	65	unpublished	\N	302	集合	1	0
19	wwe	发给发货快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快快看看看看计划计划价格回归后恢复规范化	6	\N	2014-10-07 03:05:07.417081	2015-05-31 22:30:46.286582	10	2	unpublished	\N	1	运动的描述	1	0
61	第十四讲  专题一   如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例	专题一   如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例\r\n\r\n	1	\N	2015-03-11 16:26:34.445231	2015-04-09 23:06:39.396067	10	7	unpublished	\N	2	匀变速直线运动	0	0
69	第十八讲 总结和扩充 小船过河模型的常用物理量	二、典例　小船在200 m宽的河口横渡，水流速度为3 m/s，船在静水中的航速是5 m/s，求：\r\n(1)当小船的船头始终正对对岸行驶时，它将在何时、何处到达对岸？\r\n(2)要使小船到达河的正对岸，应如何行驶？多长时间能到	2	\N	2015-04-03 15:02:08.12179	2015-04-09 23:06:39.508327	10	7	unpublished	\N	3	曲线运动	0	1
82	按时2321231313132131213	按时2321231313132131213按时2321231313132131213按时2321231313132131213	1	\N	2015-05-28 12:23:49.533415	2015-06-01 06:57:34.007631	30	2	unpublished	\N	322	机械能及其守恒定律	23	0
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('courses_id_seq', 82, true);


--
-- Data for Name: curriculums; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY curriculums (id, teacher_id, teaching_program_id, created_at, updated_at, courses_count, lessons_count, delete_topics_count) FROM stdin;
66	18	17	2015-04-09 23:06:37.857021	2015-04-09 23:06:37.857021	0	0	0
67	18	18	2015-04-09 23:06:37.862603	2015-04-09 23:06:37.862603	0	0	0
68	18	19	2015-04-09 23:06:37.866671	2015-04-09 23:06:37.866671	0	0	0
69	18	20	2015-04-09 23:06:37.870347	2015-04-09 23:06:37.870347	0	0	0
70	18	21	2015-04-09 23:06:37.874605	2015-04-09 23:06:37.874605	0	0	0
71	18	22	2015-04-09 23:06:37.879885	2015-04-09 23:06:37.879885	0	0	0
72	18	23	2015-04-09 23:06:37.883857	2015-04-09 23:06:37.883857	0	0	0
73	18	24	2015-04-09 23:06:37.887528	2015-04-09 23:06:37.887528	0	0	0
74	18	25	2015-04-09 23:06:37.89133	2015-04-09 23:06:37.89133	0	0	0
75	12	16	2015-04-09 23:06:37.894931	2015-04-09 23:06:37.894931	0	0	0
76	12	17	2015-04-09 23:06:37.899583	2015-04-09 23:06:37.899583	0	0	0
77	12	18	2015-04-09 23:06:37.903157	2015-04-09 23:06:37.903157	0	0	0
78	12	19	2015-04-09 23:06:37.906664	2015-04-09 23:06:37.906664	0	0	0
79	12	20	2015-04-09 23:06:37.910339	2015-04-09 23:06:37.910339	0	0	0
4	7	3	2015-04-09 23:06:37.917367	2015-04-09 23:06:37.917367	0	0	0
5	7	4	2015-04-09 23:06:37.920871	2015-04-09 23:06:37.920871	0	0	0
6	7	5	2015-04-09 23:06:37.924242	2015-04-09 23:06:37.924242	0	0	0
7	7	6	2015-04-09 23:06:37.928001	2015-04-09 23:06:37.928001	0	0	0
8	7	7	2015-04-09 23:06:37.931705	2015-04-09 23:06:37.931705	0	0	0
11	8	8	2015-04-09 23:06:37.935046	2015-04-09 23:06:37.935046	0	0	0
12	8	9	2015-04-09 23:06:37.938499	2015-04-09 23:06:37.938499	0	0	0
13	8	10	2015-04-09 23:06:37.94199	2015-04-09 23:06:37.94199	0	0	0
15	8	11	2015-04-09 23:06:37.94554	2015-04-09 23:06:37.94554	0	0	0
16	8	12	2015-04-09 23:06:37.94927	2015-04-09 23:06:37.94927	0	0	0
17	8	13	2015-04-09 23:06:37.953123	2015-04-09 23:06:37.953123	0	0	0
18	8	14	2015-04-09 23:06:37.956767	2015-04-09 23:06:37.956767	0	0	0
19	8	15	2015-04-09 23:06:37.96037	2015-04-09 23:06:37.96037	0	0	0
30	11	1	2015-04-09 23:06:37.990527	2015-04-09 23:06:37.990527	0	0	0
31	11	2	2015-04-09 23:06:37.994364	2015-04-09 23:06:37.994364	0	0	0
32	11	3	2015-04-09 23:06:37.99954	2015-04-09 23:06:37.99954	0	0	0
34	11	4	2015-04-09 23:06:38.004601	2015-04-09 23:06:38.004601	0	0	0
35	11	5	2015-04-09 23:06:38.008589	2015-04-09 23:06:38.008589	0	0	0
36	11	6	2015-04-09 23:06:38.012425	2015-04-09 23:06:38.012425	0	0	0
37	11	7	2015-04-09 23:06:38.01651	2015-04-09 23:06:38.01651	0	0	0
38	16	1	2015-04-09 23:06:38.022057	2015-04-09 23:06:38.022057	0	0	0
39	16	2	2015-04-09 23:06:38.025703	2015-04-09 23:06:38.025703	0	0	0
40	16	3	2015-04-09 23:06:38.030303	2015-04-09 23:06:38.030303	0	0	0
41	16	4	2015-04-09 23:06:38.033753	2015-04-09 23:06:38.033753	0	0	0
42	16	5	2015-04-09 23:06:38.03798	2015-04-09 23:06:38.03798	0	0	0
43	16	6	2015-04-09 23:06:38.041698	2015-04-09 23:06:38.041698	0	0	0
44	16	7	2015-04-09 23:06:38.04586	2015-04-09 23:06:38.04586	0	0	0
45	17	16	2015-04-09 23:06:38.051249	2015-04-09 23:06:38.051249	0	0	0
46	17	17	2015-04-09 23:06:38.055118	2015-04-09 23:06:38.055118	0	0	0
47	17	18	2015-04-09 23:06:38.059125	2015-04-09 23:06:38.059125	0	0	0
48	17	19	2015-04-09 23:06:38.075136	2015-04-09 23:06:38.075136	0	0	0
49	17	20	2015-04-09 23:06:38.07954	2015-04-09 23:06:38.07954	0	0	0
50	17	21	2015-04-09 23:06:38.083044	2015-04-09 23:06:38.083044	0	0	0
51	17	22	2015-04-09 23:06:38.08678	2015-04-09 23:06:38.08678	0	0	0
52	17	23	2015-04-09 23:06:38.09112	2015-04-09 23:06:38.09112	0	0	0
53	17	24	2015-04-09 23:06:38.095057	2015-04-09 23:06:38.095057	0	0	0
54	17	25	2015-04-09 23:06:38.099052	2015-04-09 23:06:38.099052	0	0	0
55	19	16	2015-04-09 23:06:38.102818	2015-04-09 23:06:38.102818	0	0	0
56	19	17	2015-04-09 23:06:38.106363	2015-04-09 23:06:38.106363	0	0	0
57	19	18	2015-04-09 23:06:38.109986	2015-04-09 23:06:38.109986	0	0	0
58	19	19	2015-04-09 23:06:38.113515	2015-04-09 23:06:38.113515	0	0	0
59	19	20	2015-04-09 23:06:38.117098	2015-04-09 23:06:38.117098	0	0	0
60	19	21	2015-04-09 23:06:38.120729	2015-04-09 23:06:38.120729	0	0	0
61	19	22	2015-04-09 23:06:38.12446	2015-04-09 23:06:38.12446	0	0	0
62	19	23	2015-04-09 23:06:38.128316	2015-04-09 23:06:38.128316	0	0	0
63	19	24	2015-04-09 23:06:38.132263	2015-04-09 23:06:38.132263	0	0	0
64	19	25	2015-04-09 23:06:38.136257	2015-04-09 23:06:38.136257	0	0	0
65	18	16	2015-04-09 23:06:38.140079	2015-04-09 23:06:38.140079	0	0	0
80	12	21	2015-04-09 23:06:38.143812	2015-04-09 23:06:38.143812	0	0	0
81	12	22	2015-04-09 23:06:38.147695	2015-04-09 23:06:38.147695	0	0	0
82	12	23	2015-04-09 23:06:38.151395	2015-04-09 23:06:38.151395	0	0	0
83	12	24	2015-04-09 23:06:38.155091	2015-04-09 23:06:38.155091	0	0	0
84	12	25	2015-04-09 23:06:38.15886	2015-04-09 23:06:38.15886	0	0	0
94	20	17	2015-04-09 23:06:38.191466	2015-04-09 23:06:38.191466	0	0	0
95	20	18	2015-04-09 23:06:38.195208	2015-04-09 23:06:38.195208	0	0	0
96	20	19	2015-04-09 23:06:38.198776	2015-04-09 23:06:38.198776	0	0	0
97	20	20	2015-04-09 23:06:38.202268	2015-04-09 23:06:38.202268	0	0	0
98	20	21	2015-04-09 23:06:38.205944	2015-04-09 23:06:38.205944	0	0	0
99	20	22	2015-04-09 23:06:38.209382	2015-04-09 23:06:38.209382	0	0	0
100	20	23	2015-04-09 23:06:38.212993	2015-04-09 23:06:38.212993	0	0	0
101	20	24	2015-04-09 23:06:38.232969	2015-04-09 23:06:38.232969	0	0	0
102	20	25	2015-04-09 23:06:38.236785	2015-04-09 23:06:38.236785	0	0	0
103	9	16	2015-04-09 23:06:38.240741	2015-04-09 23:06:38.240741	0	0	0
104	9	17	2015-04-09 23:06:38.244618	2015-04-09 23:06:38.244618	0	0	0
105	9	18	2015-04-09 23:06:38.249746	2015-04-09 23:06:38.249746	0	0	0
106	9	19	2015-04-09 23:06:38.253414	2015-04-09 23:06:38.253414	0	0	0
107	9	20	2015-04-09 23:06:38.257143	2015-04-09 23:06:38.257143	0	0	0
108	9	21	2015-04-09 23:06:38.260885	2015-04-09 23:06:38.260885	0	0	0
109	9	22	2015-04-09 23:06:38.264864	2015-04-09 23:06:38.264864	0	0	0
110	9	23	2015-04-09 23:06:38.26974	2015-04-09 23:06:38.26974	0	0	0
111	9	24	2015-04-09 23:06:38.273507	2015-04-09 23:06:38.273507	0	0	0
112	9	25	2015-04-09 23:06:38.277642	2015-04-09 23:06:38.277642	0	0	0
114	21	2	2015-04-09 23:06:38.281155	2015-04-09 23:06:38.281155	0	0	0
115	21	3	2015-04-09 23:06:38.285112	2015-04-09 23:06:38.285112	0	0	0
117	21	5	2015-04-09 23:06:38.289012	2015-04-09 23:06:38.289012	0	0	0
118	21	6	2015-04-09 23:06:38.292813	2015-04-09 23:06:38.292813	0	0	0
119	21	7	2015-04-09 23:06:38.296394	2015-04-09 23:06:38.296394	0	0	0
120	22	16	2015-04-09 23:06:38.301254	2015-04-09 23:06:38.301254	0	0	0
122	22	17	2015-04-09 23:06:38.305002	2015-04-09 23:06:38.305002	0	0	0
123	22	18	2015-04-09 23:06:38.308805	2015-04-09 23:06:38.308805	0	0	0
124	22	19	2015-04-09 23:06:38.312736	2015-04-09 23:06:38.312736	0	0	0
125	22	20	2015-04-09 23:06:38.316369	2015-04-09 23:06:38.316369	0	0	0
126	22	21	2015-04-09 23:06:38.320288	2015-04-09 23:06:38.320288	0	0	0
127	22	22	2015-04-09 23:06:38.324095	2015-04-09 23:06:38.324095	0	0	0
128	22	23	2015-04-09 23:06:38.327863	2015-04-09 23:06:38.327863	0	0	0
129	22	24	2015-04-09 23:06:38.332318	2015-04-09 23:06:38.332318	0	0	0
130	22	25	2015-04-09 23:06:38.336074	2015-04-09 23:06:38.336074	0	0	0
281	59	37	2015-04-12 02:15:45.257493	2015-04-12 02:15:45.257493	0	0	0
131	23	16	2015-04-09 23:06:38.347119	2015-04-09 23:06:38.347119	0	0	0
132	23	17	2015-04-09 23:06:38.350767	2015-04-09 23:06:38.350767	0	0	0
133	23	18	2015-04-09 23:06:38.354532	2015-04-09 23:06:38.354532	0	0	0
134	23	19	2015-04-09 23:06:38.358229	2015-04-09 23:06:38.358229	0	0	0
135	23	20	2015-04-09 23:06:38.361739	2015-04-09 23:06:38.361739	0	0	0
136	23	21	2015-04-09 23:06:38.365249	2015-04-09 23:06:38.365249	0	0	0
137	23	22	2015-04-09 23:06:38.368783	2015-04-09 23:06:38.368783	0	0	0
138	23	23	2015-04-09 23:06:38.372415	2015-04-09 23:06:38.372415	0	0	0
139	23	24	2015-04-09 23:06:38.375988	2015-04-09 23:06:38.375988	0	0	0
140	23	25	2015-04-09 23:06:38.379679	2015-04-09 23:06:38.379679	0	0	0
142	24	17	2015-04-09 23:06:38.383172	2015-04-09 23:06:38.383172	0	0	0
143	24	18	2015-04-09 23:06:38.387232	2015-04-09 23:06:38.387232	0	0	0
144	24	19	2015-04-09 23:06:38.392511	2015-04-09 23:06:38.392511	0	0	0
146	24	21	2015-04-09 23:06:38.396071	2015-04-09 23:06:38.396071	0	0	0
147	24	22	2015-04-09 23:06:38.39962	2015-04-09 23:06:38.39962	0	0	0
148	24	23	2015-04-09 23:06:38.403111	2015-04-09 23:06:38.403111	0	0	0
149	24	24	2015-04-09 23:06:38.406667	2015-04-09 23:06:38.406667	0	0	0
150	24	25	2015-04-09 23:06:38.41069	2015-04-09 23:06:38.41069	0	0	0
165	26	5	2015-04-09 23:06:38.453053	2015-04-09 23:06:38.453053	0	0	0
166	26	6	2015-04-09 23:06:38.456737	2015-04-09 23:06:38.456737	0	0	0
167	26	7	2015-04-09 23:06:38.460442	2015-04-09 23:06:38.460442	0	0	0
168	27	1	2015-04-09 23:06:38.464313	2015-04-09 23:06:38.464313	0	0	0
169	27	2	2015-04-09 23:06:38.468034	2015-04-09 23:06:38.468034	0	0	0
170	27	3	2015-04-09 23:06:38.471554	2015-04-09 23:06:38.471554	0	0	0
171	27	4	2015-04-09 23:06:38.476058	2015-04-09 23:06:38.476058	0	0	0
172	27	5	2015-04-09 23:06:38.480502	2015-04-09 23:06:38.480502	0	0	0
173	27	6	2015-04-09 23:06:38.484346	2015-04-09 23:06:38.484346	0	0	0
174	27	7	2015-04-09 23:06:38.488392	2015-04-09 23:06:38.488392	0	0	0
175	28	8	2015-04-09 23:06:38.492644	2015-04-09 23:06:38.492644	0	0	0
176	28	9	2015-04-09 23:06:38.496975	2015-04-09 23:06:38.496975	0	0	0
177	28	10	2015-04-09 23:06:38.500555	2015-04-09 23:06:38.500555	0	0	0
178	28	11	2015-04-09 23:06:38.50417	2015-04-09 23:06:38.50417	0	0	0
179	28	12	2015-04-09 23:06:38.50897	2015-04-09 23:06:38.50897	0	0	0
180	28	13	2015-04-09 23:06:38.512799	2015-04-09 23:06:38.512799	0	0	0
181	28	14	2015-04-09 23:06:38.516439	2015-04-09 23:06:38.516439	0	0	0
182	28	15	2015-04-09 23:06:38.520411	2015-04-09 23:06:38.520411	0	0	0
183	29	26	2015-04-09 23:06:38.523928	2015-04-09 23:06:38.523928	0	0	0
184	29	27	2015-04-09 23:06:38.527403	2015-04-09 23:06:38.527403	0	0	0
185	29	28	2015-04-09 23:06:38.53134	2015-04-09 23:06:38.53134	0	0	0
186	29	29	2015-04-09 23:06:38.534888	2015-04-09 23:06:38.534888	0	0	0
187	29	30	2015-04-09 23:06:38.538404	2015-04-09 23:06:38.538404	0	0	0
189	30	27	2015-04-09 23:06:38.54295	2015-04-09 23:06:38.54295	0	0	0
190	30	28	2015-04-09 23:06:38.546725	2015-04-09 23:06:38.546725	0	0	0
191	30	29	2015-04-09 23:06:38.550394	2015-04-09 23:06:38.550394	0	0	0
192	30	30	2015-04-09 23:06:38.554199	2015-04-09 23:06:38.554199	0	0	0
193	31	8	2015-04-09 23:06:38.557786	2015-04-09 23:06:38.557786	0	0	0
194	31	9	2015-04-09 23:06:38.561446	2015-04-09 23:06:38.561446	0	0	0
195	31	10	2015-04-09 23:06:38.565652	2015-04-09 23:06:38.565652	0	0	0
197	31	11	2015-04-09 23:06:38.569989	2015-04-09 23:06:38.569989	0	0	0
198	31	12	2015-04-09 23:06:38.573656	2015-04-09 23:06:38.573656	0	0	0
199	31	13	2015-04-09 23:06:38.577246	2015-04-09 23:06:38.577246	0	0	0
200	31	14	2015-04-09 23:06:38.58088	2015-04-09 23:06:38.58088	0	0	0
201	31	15	2015-04-09 23:06:38.584674	2015-04-09 23:06:38.584674	0	0	0
202	32	16	2015-04-09 23:06:38.601433	2015-04-09 23:06:38.601433	0	0	0
203	32	17	2015-04-09 23:06:38.605923	2015-04-09 23:06:38.605923	0	0	0
204	32	18	2015-04-09 23:06:38.611032	2015-04-09 23:06:38.611032	0	0	0
205	32	19	2015-04-09 23:06:38.615534	2015-04-09 23:06:38.615534	0	0	0
206	32	20	2015-04-09 23:06:38.619094	2015-04-09 23:06:38.619094	0	0	0
207	32	21	2015-04-09 23:06:38.622756	2015-04-09 23:06:38.622756	0	0	0
208	32	22	2015-04-09 23:06:38.64612	2015-04-09 23:06:38.64612	0	0	0
209	32	23	2015-04-09 23:06:38.649935	2015-04-09 23:06:38.649935	0	0	0
210	32	24	2015-04-09 23:06:38.653814	2015-04-09 23:06:38.653814	0	0	0
211	32	25	2015-04-09 23:06:38.657555	2015-04-09 23:06:38.657555	0	0	0
213	33	27	2015-04-09 23:06:38.661203	2015-04-09 23:06:38.661203	0	0	0
216	33	30	2015-04-09 23:06:38.664875	2015-04-09 23:06:38.664875	0	0	0
217	34	26	2015-04-09 23:06:38.66853	2015-04-09 23:06:38.66853	0	0	0
219	34	28	2015-04-09 23:06:38.673066	2015-04-09 23:06:38.673066	0	0	0
220	34	29	2015-04-09 23:06:38.676539	2015-04-09 23:06:38.676539	0	0	0
221	34	30	2015-04-09 23:06:38.68013	2015-04-09 23:06:38.68013	0	0	0
222	35	1	2015-04-09 23:06:38.683653	2015-04-09 23:06:38.683653	0	0	0
223	35	2	2015-04-09 23:06:38.687264	2015-04-09 23:06:38.687264	0	0	0
224	35	3	2015-04-09 23:06:38.691044	2015-04-09 23:06:38.691044	0	0	0
225	35	4	2015-04-09 23:06:38.69468	2015-04-09 23:06:38.69468	0	0	0
226	35	5	2015-04-09 23:06:38.698207	2015-04-09 23:06:38.698207	0	0	0
227	35	6	2015-04-09 23:06:38.702212	2015-04-09 23:06:38.702212	0	0	0
228	35	7	2015-04-09 23:06:38.706059	2015-04-09 23:06:38.706059	0	0	0
229	36	1	2015-04-09 23:06:38.709563	2015-04-09 23:06:38.709563	0	0	0
230	36	2	2015-04-09 23:06:38.713916	2015-04-09 23:06:38.713916	0	0	0
231	36	3	2015-04-09 23:06:38.718214	2015-04-09 23:06:38.718214	0	0	0
232	36	4	2015-04-09 23:06:38.722447	2015-04-09 23:06:38.722447	0	0	0
233	36	5	2015-04-09 23:06:38.726252	2015-04-09 23:06:38.726252	0	0	0
235	36	7	2015-04-09 23:06:38.730056	2015-04-09 23:06:38.730056	0	0	0
236	37	8	2015-04-09 23:06:38.733801	2015-04-09 23:06:38.733801	0	0	0
237	37	9	2015-04-09 23:06:38.737516	2015-04-09 23:06:38.737516	0	0	0
238	37	10	2015-04-09 23:06:38.742616	2015-04-09 23:06:38.742616	0	0	0
244	38	16	2015-04-09 23:06:38.746506	2015-04-09 23:06:38.746506	0	0	0
249	38	21	2015-04-09 23:06:38.750189	2015-04-09 23:06:38.750189	0	0	0
250	38	22	2015-04-09 23:06:38.75409	2015-04-09 23:06:38.75409	0	0	0
251	38	23	2015-04-09 23:06:38.757791	2015-04-09 23:06:38.757791	0	0	0
252	38	24	2015-04-09 23:06:38.761662	2015-04-09 23:06:38.761662	0	0	0
253	38	25	2015-04-09 23:06:38.765435	2015-04-09 23:06:38.765435	0	0	0
254	39	16	2015-04-09 23:06:38.769458	2015-04-09 23:06:38.769458	0	0	0
255	39	17	2015-04-09 23:06:38.773169	2015-04-09 23:06:38.773169	0	0	0
256	39	18	2015-04-09 23:06:38.777085	2015-04-09 23:06:38.777085	0	0	0
257	39	19	2015-04-09 23:06:38.780689	2015-04-09 23:06:38.780689	0	0	0
258	39	20	2015-04-09 23:06:38.784464	2015-04-09 23:06:38.784464	0	0	0
259	39	21	2015-04-09 23:06:38.789068	2015-04-09 23:06:38.789068	0	0	0
260	39	22	2015-04-09 23:06:38.793371	2015-04-09 23:06:38.793371	0	0	0
261	39	23	2015-04-09 23:06:38.798179	2015-04-09 23:06:38.798179	0	0	0
141	24	16	2015-04-09 23:06:38.593856	2015-04-09 23:06:38.593856	1	0	0
113	21	1	2015-04-09 23:06:38.626316	2015-04-09 23:06:38.626316	2	1	0
145	24	20	2015-04-09 23:06:38.6386	2015-04-09 23:06:38.6386	1	1	0
164	26	4	2015-04-09 23:06:38.589929	2015-04-09 23:06:38.589929	1	1	0
116	21	4	2015-04-09 23:06:38.635048	2015-04-09 23:06:38.635048	2	0	0
188	30	26	2015-04-09 23:06:38.343665	2015-04-09 23:06:38.343665	1	1	0
161	26	1	2015-04-09 23:06:38.642117	2015-04-09 23:06:38.642117	2	15	0
163	26	3	2015-04-09 23:06:38.631383	2015-04-09 23:06:38.631383	3	4	0
262	39	24	2015-04-09 23:06:38.803215	2015-04-09 23:06:38.803215	0	0	0
263	39	25	2015-04-09 23:06:38.808271	2015-04-09 23:06:38.808271	0	0	0
264	40	16	2015-04-09 23:06:38.812641	2015-04-09 23:06:38.812641	0	0	0
266	40	18	2015-04-09 23:06:38.816742	2015-04-09 23:06:38.816742	0	0	0
218	34	27	2015-04-09 23:06:38.826769	2015-04-09 23:06:38.826769	0	0	0
234	36	6	2015-04-09 23:06:38.83065	2015-04-09 23:06:38.83065	0	0	0
239	37	11	2015-04-09 23:06:38.834634	2015-04-09 23:06:38.834634	0	0	0
240	37	12	2015-04-09 23:06:38.83877	2015-04-09 23:06:38.83877	0	0	0
241	37	13	2015-04-09 23:06:38.84381	2015-04-09 23:06:38.84381	0	0	0
242	37	14	2015-04-09 23:06:38.847702	2015-04-09 23:06:38.847702	0	0	0
243	37	15	2015-04-09 23:06:38.851423	2015-04-09 23:06:38.851423	0	0	0
245	38	17	2015-04-09 23:06:38.8553	2015-04-09 23:06:38.8553	0	0	0
246	38	18	2015-04-09 23:06:38.859155	2015-04-09 23:06:38.859155	0	0	0
247	38	19	2015-04-09 23:06:38.863314	2015-04-09 23:06:38.863314	0	0	0
248	38	20	2015-04-09 23:06:38.867031	2015-04-09 23:06:38.867031	0	0	0
265	40	17	2015-04-09 23:06:38.870857	2015-04-09 23:06:38.870857	0	0	0
267	40	19	2015-04-09 23:06:38.875132	2015-04-09 23:06:38.875132	0	0	0
268	40	20	2015-04-09 23:06:38.879313	2015-04-09 23:06:38.879313	0	0	0
269	40	21	2015-04-09 23:06:38.88306	2015-04-09 23:06:38.88306	0	0	0
270	40	22	2015-04-09 23:06:38.887099	2015-04-09 23:06:38.887099	0	0	0
271	40	23	2015-04-09 23:06:38.890901	2015-04-09 23:06:38.890901	0	0	0
272	40	24	2015-04-09 23:06:38.894897	2015-04-09 23:06:38.894897	0	0	0
273	40	25	2015-04-09 23:06:38.898837	2015-04-09 23:06:38.898837	0	0	0
283	59	39	2015-04-12 02:15:45.268956	2015-04-12 02:15:45.268956	0	0	0
284	60	40	2015-04-12 03:27:45.921019	2015-04-12 03:27:45.921019	0	0	0
285	60	41	2015-04-12 03:27:45.928081	2015-04-12 03:27:45.928081	0	0	0
286	62	16	2015-04-12 12:59:24.987534	2015-04-12 12:59:24.987534	0	0	0
287	62	17	2015-04-12 12:59:24.99354	2015-04-12 12:59:24.99354	0	0	0
288	62	18	2015-04-12 12:59:24.998214	2015-04-12 12:59:24.998214	0	0	0
289	62	19	2015-04-12 12:59:25.002847	2015-04-12 12:59:25.002847	0	0	0
290	62	20	2015-04-12 12:59:25.007687	2015-04-12 12:59:25.007687	0	0	0
291	62	21	2015-04-12 12:59:25.013099	2015-04-12 12:59:25.013099	0	0	0
292	62	22	2015-04-12 12:59:25.017516	2015-04-12 12:59:25.017516	0	0	0
293	62	23	2015-04-12 12:59:25.022082	2015-04-12 12:59:25.022082	0	0	0
294	62	24	2015-04-12 12:59:25.026779	2015-04-12 12:59:25.026779	0	0	0
295	62	25	2015-04-12 12:59:25.03142	2015-04-12 12:59:25.03142	0	0	0
296	63	31	2015-04-12 13:37:39.896986	2015-04-12 13:37:39.896986	0	0	0
297	63	32	2015-04-12 13:37:39.902424	2015-04-12 13:37:39.902424	0	0	0
298	63	33	2015-04-12 13:37:39.906966	2015-04-12 13:37:39.906966	0	0	0
300	63	35	2015-04-12 13:37:39.916413	2015-04-12 13:37:39.916413	0	0	0
301	63	36	2015-04-12 13:37:39.92112	2015-04-12 13:37:39.92112	0	0	0
299	63	34	2015-04-12 13:37:39.911634	2015-04-12 13:37:39.911634	1	0	0
303	65	17	2015-04-13 02:23:55.19343	2015-04-13 02:23:55.19343	0	0	0
304	65	18	2015-04-13 02:23:55.19944	2015-04-13 02:23:55.19944	0	0	0
305	65	19	2015-04-13 02:23:55.205555	2015-04-13 02:23:55.205555	0	0	0
306	65	20	2015-04-13 02:23:55.210342	2015-04-13 02:23:55.210342	0	0	0
307	65	21	2015-04-13 02:23:55.215276	2015-04-13 02:23:55.215276	0	0	0
308	65	22	2015-04-13 02:23:55.220003	2015-04-13 02:23:55.220003	0	0	0
309	65	23	2015-04-13 02:23:55.224582	2015-04-13 02:23:55.224582	0	0	0
310	65	24	2015-04-13 02:23:55.229922	2015-04-13 02:23:55.229922	0	0	0
311	65	25	2015-04-13 02:23:55.235008	2015-04-13 02:23:55.235008	0	0	0
162	26	2	2015-04-09 23:06:38.597602	2015-04-09 23:06:38.597602	2	2	0
93	20	16	2015-04-09 23:06:38.22562	2015-04-09 23:06:38.22562	4	2	0
282	59	38	2015-04-12 02:15:45.263928	2015-04-12 02:15:45.263928	3	4	0
214	33	28	2015-04-09 23:06:38.902631	2015-04-09 23:06:38.902631	1	1	0
212	33	26	2015-04-09 23:06:38.82144	2015-04-09 23:06:38.82144	2	2	0
215	33	29	2015-04-09 23:06:38.934782	2015-04-09 23:06:38.934782	3	3	0
347	74	46	2015-05-09 11:30:08.426861	2015-05-09 11:30:08.426861	0	0	0
302	65	16	2015-04-13 02:23:55.185456	2015-04-13 02:23:55.185456	1	1	0
324	2	4	2015-04-18 07:39:01.278182	2015-04-18 07:39:01.278182	0	0	0
325	2	5	2015-04-18 07:39:01.283369	2015-04-18 07:39:01.283369	0	0	0
326	2	6	2015-04-18 07:39:01.289934	2015-04-18 07:39:01.289934	0	0	0
327	2	7	2015-04-18 07:39:01.294488	2015-04-18 07:39:01.294488	0	0	0
348	74	47	2015-05-09 11:30:08.434375	2015-05-09 11:30:08.434375	0	0	0
328	68	16	2015-04-19 23:08:40.197555	2015-04-19 23:08:40.197555	0	0	0
329	68	17	2015-04-19 23:08:40.209593	2015-04-19 23:08:40.209593	0	0	0
330	68	18	2015-04-19 23:08:40.215802	2015-04-19 23:08:40.215802	0	0	0
331	68	19	2015-04-19 23:08:40.220731	2015-04-19 23:08:40.220731	0	0	0
332	68	20	2015-04-19 23:08:40.2255	2015-04-19 23:08:40.2255	0	0	0
333	68	21	2015-04-19 23:08:40.230045	2015-04-19 23:08:40.230045	0	0	0
334	68	22	2015-04-19 23:08:40.235524	2015-04-19 23:08:40.235524	0	0	0
335	68	23	2015-04-19 23:08:40.239927	2015-04-19 23:08:40.239927	0	0	0
336	68	24	2015-04-19 23:08:40.244462	2015-04-19 23:08:40.244462	0	0	0
337	68	25	2015-04-19 23:08:40.248728	2015-04-19 23:08:40.248728	0	0	0
344	70	37	2015-04-19 23:25:07.646689	2015-04-19 23:25:07.646689	0	0	0
345	70	38	2015-04-19 23:25:07.653545	2015-04-19 23:25:07.653545	0	0	0
346	70	39	2015-04-19 23:25:07.661211	2015-04-19 23:25:07.661211	0	0	0
349	74	48	2015-05-09 11:30:08.439639	2015-05-09 11:30:08.439639	0	0	0
350	74	49	2015-05-09 11:30:08.444306	2015-05-09 11:30:08.444306	0	0	0
351	74	50	2015-05-09 11:30:08.449176	2015-05-09 11:30:08.449176	0	0	0
352	74	51	2015-05-09 11:30:08.453856	2015-05-09 11:30:08.453856	0	0	0
353	74	52	2015-05-09 11:30:08.4581	2015-05-09 11:30:08.4581	0	0	0
354	74	53	2015-05-09 11:30:08.462378	2015-05-09 11:30:08.462378	0	0	0
323	2	3	2015-04-18 07:39:01.272105	2015-04-18 07:39:01.272105	1	3	2
322	2	2	2015-04-18 07:39:01.264337	2015-04-18 07:39:01.264337	2	1	0
2	7	1	2015-04-09 23:06:38.938759	2015-04-09 23:06:38.938759	20	17	0
3	7	2	2015-04-09 23:06:38.229342	2015-04-09 23:06:38.229342	5	5	1
1	2	1	2015-04-09 23:06:38.340087	2015-04-09 23:06:38.340087	2	26	0
\.


--
-- Name: curriculums_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('curriculums_id_seq', 354, true);


--
-- Data for Name: customized_course_assignments; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY customized_course_assignments (id, customized_course_id, teacher_id, created_at, updated_at) FROM stdin;
1	2	2	2015-08-24 07:46:21.556814	2015-08-24 07:46:21.556814
2	3	76	2015-10-10 13:32:18.513674	2015-10-10 13:32:18.513674
\.


--
-- Name: customized_course_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('customized_course_assignments_id_seq', 2, true);


--
-- Data for Name: customized_courses; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY customized_courses (id, student_id, category, subject, created_at, updated_at, customized_tutorials_count, topics_count, homeworks_count, exercises_count, tutorial_issues_count, course_issues_count) FROM stdin;
1	75	高中	物理	2015-08-24 06:33:07.806399	2015-08-24 06:33:07.806399	0	0	0	0	0	0
2	75	高中	物理	2015-08-24 06:33:24.700174	2015-08-24 06:33:24.700174	12	7	1	8	5	0
3	75	高中	物理	2015-10-10 13:32:18.508718	2015-10-10 13:32:18.508718	2	0	3	2	2	3
\.


--
-- Name: customized_courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('customized_courses_id_seq', 3, true);


--
-- Data for Name: customized_tutorials; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY customized_tutorials (id, teacher_id, customized_course_id, title, content, "position", token, created_at, updated_at, topics_count, exercises_count, tutorial_issues_count, status) FROM stdin;
2	2	2	测试一下看看是否有什么确定可以	测试是否可以增长	0	1443229207-0dHF-i7-S7UukrllFeHQ6g	2015-09-26 01:01:28.298476	2015-09-26 01:01:28.298476	0	0	0	false
3	2	2	ddddd	ssss	0	1443318111-wMAmyPI0XkOvcv2cR-Oxbg	2015-09-27 01:41:59.291556	2015-09-27 01:41:59.291556	0	0	0	false
4	2	2	reqwe	11	0	1443318129-cO3hZmJKt8NeYAJQNn7DDg	2015-09-27 01:42:16.613255	2015-09-27 01:42:16.613255	0	0	0	false
6	2	2	ceshi fanye	ceshi fanye	0	1443318168-useG0kEPae0p0Q8q5i-uZw	2015-09-27 01:42:57.180717	2015-09-27 01:42:57.180717	0	0	0	false
7	2	2	ceshi fanye	ceshi fanye	0	1443318186-EJlDUSQBZQnQVl_ldMltZQ	2015-09-27 01:43:16.105808	2015-09-27 01:43:16.105808	0	0	0	false
8	2	2	测试最后能不能翻页	测试最后能不能翻页	0	1443318555-HTNH0j0ems-FaOHe28hJhg	2015-09-27 01:49:33.02497	2015-09-27 01:49:33.02497	0	0	0	false
9	2	2	测试最后不翻页	测试最后不翻页	0	1443318588-oakAwYtTaXXGK58yd3IENQ	2015-09-27 01:49:59.722111	2015-09-27 01:49:59.722111	0	0	0	false
10	2	2	发野	发 	0	1443318616-E6pDueo7x0CByRZ2OjHgjg	2015-09-27 01:50:27.125577	2015-09-27 01:50:27.125577	0	0	0	false
11	2	2	测试啊	测试啊	0	1443318641-9cqJRaadE1TzdL23bz1nXg	2015-09-27 01:50:52.85044	2015-09-27 01:50:52.85044	0	0	0	false
1	2	2	ceshi ceshiceshi ceshi	ceshi ceshiceshi ceshiceshi ceshiceshi ceshi	0	1442319778-22x2ktceTNNj6w78eGIEEA	2015-09-15 12:23:14.41211	2015-09-15 12:23:14.41211	1	5	0	false
12	2	2	ceshi yixa	ceshi yixa	0	1443480883-83AJBEzLBDXBeD57djgKiA	2015-09-28 22:55:12.389189	2015-09-28 22:55:12.389189	0	0	1	false
14	76	3	cash 	cash	0	1444483952-SqJcodpleza4VMgQqgPsPw	2015-10-10 13:33:28.666158	2015-10-10 13:42:24.283513	0	0	0	closed
13	2	2	测试一下么啊	测试一下么啊测试一下么啊	0	1443481864-W_gKimHJ3tB9VKZT5NLAUg	2015-09-28 23:11:31.50045	2015-09-28 23:11:31.50045	6	3	6	false
15	76	3	dfsfs	asdfasdfafsafs	0	1444484627-jwUgAHWOMD7OgtS_2JlpoQ	2015-10-10 13:44:43.891788	2015-10-10 14:19:05.820556	1	3	2	closed
\.


--
-- Name: customized_tutorials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('customized_tutorials_id_seq', 15, true);


--
-- Data for Name: earning_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY earning_records (id, fee_id, account_id, percent, value, created_at, updated_at) FROM stdin;
6	6	88	1	0.630000000000000004	2015-10-18 01:22:32.890064	2015-10-18 01:22:32.890064
7	7	88	1	0.630000000000000004	2015-10-18 01:58:11.294757	2015-10-18 01:58:11.294757
8	8	88	1	0.630000000000000004	2015-10-25 00:18:18.284393	2015-10-25 00:18:18.284393
9	9	88	1	0.630000000000000004	2015-10-25 02:29:17.125097	2015-10-25 02:29:17.125097
\.


--
-- Name: earning_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('earning_records_id_seq', 9, true);


--
-- Data for Name: examinations; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY examinations (id, customized_course_id, teacher_id, title, content, token, topics_count, created_at, updated_at, solutions_count, student_id, customized_tutorial_id, comments_count, corrections_count, work_type, type) FROM stdin;
7	2	2	测试是否可以仅需发送短信	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/c582eeb5d14132ddc23d9f7d62f94692.jpg" style="width: 1128px;"></p>	1441786862-TXXJTBgX3z3wM7A08tbNhA	0	2015-09-09 08:21:52.951624	2015-09-21 01:46:22.96715	0	75	\N	0	0	\N	Homework
6	2	2	测试是否可以发送短信	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/844d7641e00de06e8ceb38beb019ffc7.jpg" style="width: 25%;"></p><p>测试感觉还是不错滴</p><p>哈哈哈哈哈哈哈</p>	1441786642-8TGfNHzEKEneBstzanC_IA	0	2015-09-09 08:18:06.743595	2015-09-21 01:46:22.934053	1	75	\N	0	0	\N	Homework
9	2	2	ceshi yixia	okokoko	1443134338-6bOj4yCK41vVHPFVMmmmJw	0	2015-09-24 22:39:11.090968	2015-09-24 22:39:11.090968	3	75	\N	0	5	\N	Homework
8	2	2	继续测试，看看能否发送短息	看看能否发送短息啊啊啊啊嗄	1441787068-glLyLG76QibVw6N2ri9dPg	0	2015-09-09 08:30:43.24876	2015-09-21 01:46:22.973154	1	75	\N	0	1	\N	Homework
5	2	2	测试下是否可以使用	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/aa5730af43a434c7a69ede693275bc9a.jpg" style="width: 25%;"></p><p>哈哈哈</p>	1441775528-6Nb6fjRAfp1CiLvgmEbQ_Q	1	2015-09-09 05:16:42.473051	2015-09-21 01:46:22.979306	1	75	\N	0	9	\N	Homework
18	3	76	sdfdsafsdf	adsfasfdasdf	1444485483-huSILAiIWTTRwQOESD67kQ	0	2015-10-10 13:58:27.263356	2015-10-10 13:58:27.263356	1	75	\N	0	1	\N	Homework
10	2	2	看看怎么样么111		1442903924-QawoiFIfGLAPoHv_Krt8Iw	0	2015-09-22 06:39:07.200626	2015-10-01 11:21:21.909408	0	75	1	0	0	exercise	Exercise
11	2	2	keyide	keyide sss	1442904957-cmsujdRC51Z02YMzQUwbuw	0	2015-09-22 06:56:06.544921	2015-10-01 11:21:21.928201	0	75	1	0	0	exercise	Exercise
12	2	2	ccfasdfa	sss	1442899644-ushCGD06qUJF5etDxc2y9Q	0	2015-09-22 05:27:34.298872	2015-10-01 11:21:21.93308	0	75	1	0	0	exercise	Exercise
13	2	2	23423412341234123412	安师大发啥地方	1442905070-K_djlHX6nMBxIhbPgOKP6A	0	2015-09-22 06:58:06.040722	2015-10-01 11:21:21.937492	0	75	1	0	0	exercise	Exercise
14	2	2	测试以下看看啊嘛		1442897586-XKk_lhGRfdup_xtPzqaOIw	0	2015-09-22 04:53:19.888308	2015-10-01 11:21:21.942323	1	75	1	0	0	exercise	Exercise
15	2	2	asdfasdf	asdfasdf	1444193898-Fxan8z1lCcNrJ9okNgso_A	0	2015-10-07 04:58:32.380844	2015-10-07 04:58:32.380844	0	75	13	0	0	exercise	Exercise
16	2	2	aaaddd	asdfadf	1444197635-ht3f3TzMiUA0BJL4wtHtKw	0	2015-10-07 06:00:49.030575	2015-10-07 06:00:49.030575	0	75	13	0	0	exercise	Exercise
17	2	2	1111	333	1444197716-g1ZIbnTemVd3d-CXqWUKaw	0	2015-10-07 06:02:10.000853	2015-10-07 06:02:10.000853	0	75	13	0	0	exercise	Exercise
21	3	76	ceshi	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/87349fa9d1dc15ccc60826b2092cad10.JPG" style="width: 414px;"></p>	1445386591-Rhz0bUuCA4b35s_tdPnb8Q	0	2015-10-21 00:19:47.63678	2015-10-21 00:19:47.63678	1	75	15	0	0	\N	Homework
20	3	76	1234	1234	1445377833-KSNcYRluVxmFuubuc_3Djg	0	2015-10-20 21:50:43.883698	2015-10-20 21:50:43.883698	3	75	15	0	1	exercise	Exercise
23	3	76	asdfasdf	asdfasdfasdf	1445646725-DZRWwgcfD1QiJI54qmyJrA	0	2015-10-24 00:32:13.922978	2015-10-24 00:32:13.922978	0	75	\N	0	0	\N	Homework
19	3	76	asdfasf	asdfasdfasdfa	1445376653-zCMt3K5fiS0m3v6MF2M8iA	0	2015-10-20 21:31:04.079655	2015-10-20 21:31:04.079655	3	75	15	0	1	exercise	Exercise
22	3	76	ccccsswe	dddsssqqq	1445515886-i4lz6KSvk0uoLVenPpiRoA	0	2015-10-22 12:11:39.470899	2015-10-24 00:31:42.671322	1	75	\N	0	3	\N	Homework
\.


--
-- Name: examinations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('examinations_id_seq', 23, true);


--
-- Data for Name: excercises; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY excercises (id, token, title, content, teacher_id, customized_tutorial_id, solutions_count, created_at, updated_at) FROM stdin;
\.


--
-- Name: excercises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('excercises_id_seq', 1, false);


--
-- Data for Name: exercises; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY exercises (id, token, title, content, teacher_id, customized_tutorial_id, solutions_count, created_at, updated_at, comments_count, student_id, customized_course_id) FROM stdin;
3	1442903924-QawoiFIfGLAPoHv_Krt8Iw	看看怎么样么111		2	1	0	2015-09-22 06:39:07.200626	2015-10-01 11:21:21.909408	0	75	2
4	1442904957-cmsujdRC51Z02YMzQUwbuw	keyide	keyide sss	2	1	0	2015-09-22 06:56:06.544921	2015-10-01 11:21:21.928201	0	75	2
2	1442899644-ushCGD06qUJF5etDxc2y9Q	ccfasdfa	sss	2	1	0	2015-09-22 05:27:34.298872	2015-10-01 11:21:21.93308	0	75	2
5	1442905070-K_djlHX6nMBxIhbPgOKP6A	23423412341234123412	安师大发啥地方	2	1	0	2015-09-22 06:58:06.040722	2015-10-01 11:21:21.937492	0	75	2
1	1442897586-XKk_lhGRfdup_xtPzqaOIw	测试以下看看啊嘛		2	1	0	2015-09-22 04:53:19.888308	2015-10-01 11:21:21.942323	0	75	2
\.


--
-- Name: exercises_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('exercises_id_seq', 5, true);


--
-- Data for Name: faq_topics; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY faq_topics (id, title, user_type, created_at, updated_at, user_id) FROM stdin;
1	软件安装	teacher	2014-08-02 05:14:19.047637	2014-08-02 05:14:19.047637	1
2	创建课程	teacher	2014-08-02 05:15:09.415948	2014-08-02 05:15:09.415948	1
3	视频制作	teacher	2014-08-02 05:15:42.573766	2014-08-02 05:15:42.573766	1
4	问答	teacher	2014-08-02 05:16:17.075225	2014-08-02 05:16:17.075225	1
5	选择课程	student	2014-08-02 05:17:17.805563	2014-08-02 05:17:17.805563	1
6	充值	student	2014-08-02 05:18:02.339578	2014-08-02 05:18:02.339578	1
7	问答	student	2014-08-02 05:18:24.218629	2014-08-02 05:18:24.218629	1
\.


--
-- Name: faq_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('faq_topics_id_seq', 8, false);


--
-- Data for Name: faqs; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY faqs (id, name, "desc", token, user_id, created_at, updated_at, faq_type, faq_topic_id, is_top, video_url) FROM stdin;
2	老师如何修改课程	<h3>前言</h3><p>如下一些情况下，老师需要修改自己的课程：</p><ul><li>修改课程名、课程描述、课程价格等信息</li><li>为课程添加了视频内容后，老师想要发布该课程<br></li></ul><h3>修改课程</h3><ul><li>用户点击自己想要修改的课程，如下图所示：</li></ul><p>          <img style="width: 446.343px; height: 86.75px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/53f172d8ffda00d85768423eff8ca94c.jpg"></p><ul><li>点击如下图所示的编辑按钮，进入编辑界面</li></ul><p>         <img style="width: 407.9px; height: 79.2784px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/ef84a7bf35c9d3e382c3568c6509f36d.jpg"></p><ul><li>如下图所示，对想要修改的内容进行修改，点击保存，完成修改。</li></ul><p>         <img style="width: 718.207px; height: 414.717px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/a9e01115c10fb921f2d490e338bd3325.jpg"><br></p>	2ZKCr4BrQtMl6mlJn5xB1w	1	2014-08-04 15:51:56.482359	2014-08-04 15:55:07.47899	老师	2	0	
1	同步辅导班添加课程的过程说明	<h3><span style="font-weight: normal;">前言</span></h3><p>网站管理员会根据老师负责的科目创建好各个阶段的同步辅导班，老师只要为各个同步辅导班添加相应课程即可。</p><h3>创建课程</h3><div><ul><li>老师登录后会看到自己的各个同步辅导班。</li></ul><ul><li>点击选中的同步辅导班，会看到已有的课程列表，如下图所示：</li></ul><p>           <img style="width: 654.207px; height: 172.4px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/dc9ef5def6a3a4855cb0b3fa8a2ae802.jpg"><br></p><ul><li>点击新建课程按钮，如下图所示，会看到课程的表单页面。</li></ul><p>          <img style="width: 698.34px; height: 402.717px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/cca143c63e5c45e5ce4ea12afa17be72.jpg"></p><ul><li>选择这次添加课程的章节、输入课程名字、输入课程的描述（为了更清楚的表达课程表达的内容，这里课程描述内容不能低于30个字），点击新增课程即可创建一个课程。</li></ul><h3>补充说明</h3><ul><li>因为初次创建课程，里面并没有视频内容，因此刚创建的课程无法发布，必须添加相应视频讲课内容后才能发布。</li><li>课程价格目前还在调研阶段，这里只是举例，后面会随着市场调研的结果而调整。<br></li></ul></div>	AjLqOoJFzERMyn8U1bNyaA	1	2014-08-04 14:33:26.530044	2014-08-04 15:58:57.341201	老师	2	1	
3	老师操作概述	<h3>前言</h3><p>这个概述主要是对老师需要做的事情做个概述，让老师对整个平台有个大概的了解。</p><h3>操作概述</h3><ul><li>在答疑时间这个平台上，老师的主要操作如下图所示：</li></ul><p>           <img style="width: 360.1px; height: 575.225px;" src="http://qatime.oss-cn-beijing.aliyuncs.com/images/d4a669914ae71a25ab9f038af79be8c1.jpg"></p><ul><li>对以上过程描述如下：</li><ul><li>为老师创建用户：和老师确认授课科目、邮箱等基本信息后，管理员会为老师创建账号，并将用户名和密码通过邮箱的方式发给老师。</li><li>为老师创建辅导班：管理员根据老师教授科目、该科目的教学安排为老师创建辅导班。</li><li>修改密码：老师收到用户名密码后请马上登陆修改密码。</li><li>为辅导班添加课程：老师根据各个辅导班教学任务的不同，设计好该辅导班的课程内容，并将信息录入到系统中。</li><li>上传视频、发布课程：老师制作各个课程的视频，并将视频添加到对应的课程里面，完成全部视频后，发布该课程。</li><li>维护问答群：学生购买后，会加入老师维护的qq问答群，老师需要回答问答群里面的问题，完成答疑。<br></li></ul></ul>	S4yn1DVDa9M27cW1YNTlag	1	2014-08-05 13:44:25.055938	2014-08-05 14:14:34.739935	老师	2	1	
4	软件安装	主要用到的软件为offlice，我们会有专人为各位老师安装。请老师联系，手机号为：<br><br>	zLQScd65yIutrTTQD-_Otg	1	2014-08-07 13:49:48.014914	2014-08-07 13:49:48.014914	老师	1	0	
5	问答群的维护	<h3>前言</h3><p>传道授业解惑中，解惑是一个非常重要的环节。在答疑时间平台上，学生看完老师的视频后会产生一系列问题，老师需要维护问答群，回答学生的问题。</p><h3>具体操作</h3><ul><li>给老师开通账号后，我们会为每位老师创建qq问答群，老师是群主。</li><li>学生购买老师的课程后，可以加入老师的qq群进行提问。</li><li>老师可以群回也可以私聊来向学生提供解答。</li><li>老师可以将一些常用的资料和课程的预告信息通知在qq群中。<br></li></ul>	3nTczlbRs-USN_KY_P8NdQ	1	2014-08-07 14:03:33.031529	2014-08-07 14:03:33.031529	老师	4	0	
6	为课程添加视频		_lpx8a63amA27R0QUiFJHg	1	2014-08-07 14:04:15.657727	2014-08-07 14:48:10.116409	老师	2	1	http://qatime.oss-cn-beijing.aliyuncs.com/videos/3c9e16d7cbaca962103e397eb554dd1b.mp4
\.


--
-- Name: faqs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('faqs_id_seq', 7, false);


--
-- Data for Name: fees; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY fees (id, customized_course_id, feeable_id, feeable_type, value, created_at, updated_at, price_per_minute, video_duration) FROM stdin;
6	3	71	Reply	0.630000000000000004	2015-10-18 01:22:32.826733	2015-10-18 01:22:32.826733	0.900000000000000022	42
7	3	72	Reply	0.630000000000000004	2015-10-18 01:58:11.23086	2015-10-18 01:58:11.23086	0.900000000000000022	42
8	3	30	Correction	0.630000000000000004	2015-10-25 00:18:18.07704	2015-10-25 00:18:18.07704	0.900000000000000022	42
9	3	31	Correction	0.630000000000000004	2015-10-25 02:29:17.082178	2015-10-25 02:29:17.082178	0.900000000000000022	42
\.


--
-- Name: fees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('fees_id_seq', 9, true);


--
-- Data for Name: learning_plan_assignments; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY learning_plan_assignments (id, learning_plan_id, teacher_id, answered_questions_count, created_at, updated_at) FROM stdin;
12	5	70	0	2015-04-21 06:31:29.938778	2015-04-21 06:31:29.94236
18	4	18	0	2015-04-21 06:40:14.833941	2015-04-21 06:40:14.833941
19	4	12	0	2015-04-21 06:40:14.836771	2015-04-21 06:40:14.836771
20	6	11	0	2015-04-21 06:52:25.866036	2015-04-21 06:52:25.866036
21	6	26	0	2015-04-21 06:52:25.869545	2015-04-21 06:52:25.869545
22	7	2	0	2015-04-21 08:48:28.805422	2015-04-21 08:48:28.807677
23	8	2	0	2015-04-21 08:49:04.501993	2015-04-21 08:49:04.504358
24	9	2	0	2015-04-21 08:49:25.169824	2015-04-21 08:49:25.171882
25	10	2	0	2015-04-21 08:50:35.160089	2015-04-21 08:50:35.16226
36	21	2	0	2015-08-24 05:59:45.800944	2015-08-24 05:59:45.804276
37	22	68	0	2015-08-24 05:59:45.843437	2015-08-24 05:59:45.845815
38	23	2	0	2015-08-24 05:59:45.864499	2015-08-24 05:59:45.866204
39	24	2	0	2015-08-24 05:59:45.885137	2015-08-24 05:59:45.886787
40	21	26	0	2015-08-24 05:59:45.994623	2015-08-24 05:59:45.994623
41	21	7	0	2015-08-24 05:59:46.002576	2015-08-24 05:59:46.002576
\.


--
-- Name: learning_plan_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('learning_plan_assignments_id_seq', 41, true);


--
-- Data for Name: learning_plans; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY learning_plans (id, duration_type, state, student_id, vip_class_id, price, begin_at, end_at, questions_count, answered_questions_count, created_at, updated_at) FROM stdin;
21	新建	\N	61	2	\N	2015-08-24 05:59:45.545429	2015-08-24 05:59:45.545561	0	0	2015-08-24 05:59:45.796695	2015-08-24 05:59:45.796695
22	新建	\N	73	1	\N	2015-08-24 05:59:45.828784	2015-08-24 05:59:45.828892	0	0	2015-08-24 05:59:45.841535	2015-08-24 05:59:45.841535
23	新建	\N	72	2	\N	2015-08-24 05:59:45.849554	2015-08-24 05:59:45.849679	0	0	2015-08-24 05:59:45.862453	2015-08-24 05:59:45.862453
24	新建	\N	75	2	\N	2015-08-24 05:59:45.870377	2015-08-24 05:59:45.87049	6	0	2015-08-24 05:59:45.883176	2015-08-24 05:59:45.883176
\.


--
-- Name: learning_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('learning_plans_id_seq', 24, true);


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY lessons (id, name, "desc", course_id, token, created_at, updated_at, teacher_id, curriculum_id, state, topics_count, tags) FROM stdin;
2	看到了吧，看到了吧，看到了吧，看到了吧，看到了吧	看到了吧看到了吧看到了吧看到了吧看到了吧看到了吧	2	jEi95siAAFxxMJ3wiWGqOQ	2014-06-27 05:29:40.429112	2015-04-09 23:06:39.555132	2	1	init	0	[]
3	U888888888	JHMFMHFMHFMFTMT	3	HfoWLacqf0oidU079s5WTg	2014-06-27 07:09:49.747025	2015-04-09 23:06:39.561254	2	1	init	0	[]
4	FFSFDDSFDFSFDSF	13ER132R123R123R123RE123R	3	vYqLl7EvAxYHPS-WRINIRg	2014-06-27 07:10:43.413588	2015-04-09 23:06:39.569052	2	1	init	0	[]
5	KJKJKJKKJKJL.KJ.JG.JHG.JHJ,HFH,FMHGFMGDNBDBFDBFDSBDSF 	HFMHGFMHGFH GF HFG HGF HGF HGFH GF HGDNRSNR	4	ArbdaKgiD38PHGU2vIunQg	2014-06-27 07:31:17.077594	2015-04-09 23:06:39.575727	2	1	init	0	[]
6	888888	99999999999	4	PiWSwKV6H7RHuLzxGupyEw	2014-06-27 07:31:40.837574	2015-04-09 23:06:39.581591	2	1	init	0	[]
7	ggggggg	55555555555577777	5	3srhRnDyBv4WhJDJaSEm4A	2014-06-27 07:42:26.114934	2015-04-09 23:06:39.587614	2	1	init	0	[]
8	牛顿定律	按时到发送发	6	mUHjL1X2JsMMXS6QHl0Chg	2014-06-27 08:29:56.95077	2015-04-09 23:06:39.593817	2	1	init	0	[]
9	点对点	收拾收拾	6	0zfI05DEVus6yN6jERUVYg	2014-06-27 08:31:41.123039	2015-04-09 23:06:39.600301	2	1	init	0	[]
10	12341234	qwerqwrqwrwqrqwer	7	DCH58BwFePS1BuTddYLauA	2014-06-27 08:42:39.221324	2015-04-09 23:06:39.607934	2	1	init	0	[]
11	解题技巧一	解题技巧一解题技巧一解题技巧一解题技巧一解题技巧一解题技巧一解题技巧一	8	-pgjzNhZUqq2lP5c1-Cbjg	2014-06-27 10:07:44.653787	2015-04-09 23:06:39.61462	2	1	init	0	[]
12	解题技巧二	解题技巧一解题技巧一解题技巧一解题技巧一解题技巧一解题技巧一	8	HnJsPDhze0Qbt-9QfBP-Rg	2014-06-27 10:08:17.416059	2015-04-09 23:06:39.62043	2	1	init	0	[]
14	牛顿第二定律	牛顿第二定律很重要	2	dJ-kY8gUdH3eDXWaMPJX8w	2014-06-28 07:23:03.409864	2015-04-09 23:06:39.632823	2	1	init	0	[]
20	4444444444444	4444444444444444444444444	16	wNDVy4c-pkw29ilvfMZ4OA	2014-09-29 08:47:08.690748	2015-04-09 23:06:39.645038	20	93	init	0	[]
23	机械能守恒定律的误区	这节内容主要归纳了学生们在学习机械能守恒定律时由于不能正确理解定律的守恒条件而在使用的过程中出现的一些错误理解和应用。	21	QGUKCutr6VDfyfdbbm7XEQ	2014-10-22 12:04:18.843495	2015-04-09 23:06:39.651162	26	162	init	0	[]
25	变力做功的处理方法	学生们在学习功的时候，碰到变力做功时，经常很难下手，本节课从多个方面介绍了变力做功的处理方法。	23	FmM2GboB1cTRE1IelS0cJA	2014-10-23 14:31:59.781845	2015-04-09 23:06:39.657455	26	162	init	0	[]
28	mm	mm	27	vUjP-OXhk6LrR6B5PnTx_g	2014-10-31 09:31:42.919225	2015-04-09 23:06:39.663229	20	93	init	0	[]
31	真核生物与原核生物的区别	从大小、细胞核、细胞器、染色体、细胞分裂等多方面讲解了原核生物和真核生物的区别，以及一些特殊的例子。	25	cfwWp79J2qV4NJBJzk9yvw	2014-11-03 00:18:42.365296	2015-04-09 23:06:39.686557	30	188	init	0	[]
32	第四讲 ：关于“用打点计时器测速度”实验的几点说明\v	3、为什么电磁打点计时器、电火花计时器工作时必须使用交流电?\r\n  答：因为直流电的方向不改变，不会使计时器作周期性的变化-----工作在通与断之间,要么打不上，要么打下一条直线，起不到计时的作用。    \r\n	35	T2I60OnEp2S7CFUKrrYYDg	2014-11-03 07:23:26.947435	2015-04-09 23:06:39.693475	7	2	init	0	[]
34	细胞呼吸和液滴移动问题	细胞呼吸方式的判定是高考重点也是难点，细胞呼吸包括有氧呼吸和无氧呼吸，尤其是根据有关装置液滴移动的移动方向来判定有关呼吸作用方式。	37	M_-thDQ52zOEuGgGcEA4hg	2014-11-10 09:29:42.649243	2015-04-09 23:06:39.699728	33	212	init	0	[]
36	电势高低判定方法	这节内容主要通过一个例题来研究利用电势的定义来判断电势的高低的方法。	39	tp0vhU-enUfD8PUlDlnmMg	2014-11-11 12:58:56.100262	2015-04-09 23:06:39.706704	26	163	init	0	[]
37	电势高低的判定方法二	这节内容主要通过一个例题来研究通过电势差来判定电势高低的方法。	39	HEbPwvIMLJ1WiUycS67OvQ	2014-11-11 13:02:08.91823	2015-04-09 23:06:39.71377	26	163	init	0	[]
38	电势高低判定方法三	这节内主要从两个方面介绍了电势高低的判定方法，一是根据电场的 方向与电势升降关系判定，另一个是从做功的角度来判定。	39	Gx987aX_i12dWUShnQtlXQ	2014-11-11 13:04:37.241952	2015-04-09 23:06:39.722277	26	163	init	0	[]
39	血球计数板的使用	该视屏内容针对教材上探究培养液中酵母菌种群数量的变化实验中的关于对酵母菌细胞的计数问题，由于课本上对计数只是简短的概述，学生对这块内容很难理解，尤其是考出关于酵母细胞计数这一块习题很难下手特录制此视屏。（晚上录制的声音需要调大）	41	-ihUjHu0XONeaHXWqsP6OA	2014-11-13 04:28:28.17138	2015-04-09 23:06:39.728273	33	214	init	0	[]
40	胡萝卜素的提取	了解胡萝卜素的基础知识和提取原理；学会提取胡萝卜素的技术和纸层析的操作要求。\r\n	42	dtEpbLL5BFRQfIeTfZuvZA	2014-11-13 04:43:02.24344	2015-04-09 23:06:39.734364	33	215	init	0	[]
21	第一讲  质点、参考系和坐标系2	1、为什么要引入质点；2、物体能否视为质点的原则；3、对参考系的理解；4选择坐标系应注意的几个问题。	14	WLgS7nc9BcMR1gLxkOx_iw	2014-09-30 04:11:53.320679	2015-04-09 23:06:39.7406	7	2	init	0	[]
22	第二讲  科学设计坐标系的最小长度和单位	标度设计的要求是：既不能太大也不能太小。太大了纸放不下，太小了误差大，又不美观。 \r\n	20	JjpJDwSBnQTAYCOM9ViRCg	2014-10-19 05:21:12.288679	2015-04-09 23:06:39.747394	7	2	init	0	[]
33	第三讲  速度重点提示	1、速度的分类\r\n2、日常说法和教材概念的区别\r\n3、解题时如何正确理解题中的速度含义\r\n	24	kumYjQhXYt2LTcd0WTpJiA	2014-11-06 08:02:13.363976	2015-04-09 23:06:39.753205	7	2	init	0	[]
35	第五讲 加速度	加速度是同学们进入高中以来，继位移之后的第二个全新的物理量。从好奇心的角度已经足够重视了，但要真正理解加速度概念还必须注意以下几点：\r\n	38	okjUQX4AIhQF1OkLKiMKYQ	2014-11-10 15:12:39.219714	2015-04-09 23:06:39.75942	7	2	init	0	[]
41	全面理解加速度（二）	8、趣味理解加速度与速度的关系\r\n（1）  加速度增加的加速运动：就好比每天往银行存款的数目增加，第一天存10元、第二天存20元、第三天存30元……，银行账户的总额当然会增加。\r\n	43	xKB91D7e13uKW8xwLtzGSw	2014-11-18 11:30:19.930659	2015-04-09 23:06:39.774037	7	2	init	0	[]
44	影响酶活性的条件	影响酶活性的条件	46	2yibAhmFWiNv6xQnGYY9yQ	2014-12-14 23:54:25.539224	2015-04-09 23:06:39.786265	33	212	init	0	[]
45	果酒果醋的制作	本部分包括知识梳理、核心突破、习题精析，通过学习能掌握基础部分	47	jhhm5Xh1tHE5ny9WI-ttkA	2014-12-15 00:16:51.552155	2015-04-09 23:06:39.792502	33	215	init	0	[]
46	腐乳的制作	腐乳的制作	48	IMCKHXSuVW-IaLN2HykaYQ	2014-12-15 00:34:11.426311	2015-04-09 23:06:39.798361	33	215	init	0	[]
47	第八讲  第二章   解题归类（一）	要养成画物体运动示意图或v－t图象\r\n的习惯，特别是较复杂的运动，画出示意图或v－t图象可使运动过程直观，物理过程清晰，便于分析研究．\r\n	49	T9NxvLU1ZheE5r9I-DhqEA	2014-12-29 01:31:32.448409	2015-04-09 23:06:39.804367	7	2	init	0	[]
49	画等效电路的方法	电路的化简有各种各样的方法，这部分内容主要介绍了一种用等势线来化简电路的方法。	53	FHpGXrdF2gXevyouOBzYFg	2015-01-12 14:26:10.759734	2015-04-09 23:06:39.811894	26	163	init	0	[]
50	用纸带分析物体的运动，求物体的瞬时速度和加速度	       用纸带分析物体的运动，求物体的瞬时速度和加速度，一直都是高中物理的热点、重点和难点知识。	54	HlDM4k9ZKPa_aWL5Qrdgdw	2015-01-13 08:33:43.352036	2015-04-09 23:06:39.819985	21	113	init	0	[]
51	第九讲  第二章   解题归类（二）	由于运动学部分的公式较多，并且各公式之间又相互联系，所以本章中的一些题目常可一题多解．因此在解题时要思路开阔，联想比较，筛选出最为便捷的解题方案，从而简化解题过程．本章的常用解题方法及规律特点见下表：\r\n	55	v-KF2LkIcgF_VN3mrVI-GQ	2015-01-15 05:30:48.088849	2015-04-09 23:06:39.825857	7	2	init	0	[]
53	第十讲 专题一 巧解追击和相遇问题（一）	追击和相遇问题是运动学不可回避的问题，问题很多，方法也不少。但追其本质有一种“巧妙思维”：那就是始终以“慢速”物体为参考系，可解决任何问题。\r\n	56	OSdJwYayBtFbgO5xCB1eCQ	2015-02-14 15:44:55.173507	2015-04-09 23:06:39.831847	7	2	init	0	[]
54	第十一讲 专题一   如何“巧”解追击和相遇问题(二)	匀慢A在前，快减B在后。此情况也分两阶段：第一阶段、共速之前，以慢A为参考系，快B一直在靠近慢A；第二阶段：共速之后，由于B减速A匀速，所以B速小于A，改以B为参考系，A在远离B，所以二者共速时间距最小。若在共速之前B追不上A，以后就再也追不上了。所以，A、B恰好不撞的条件为二者相遇时恰好共速。\r\n	57	E1UIV6cu_wP1UNBz0jCF3Q	2015-02-21 10:03:17.091668	2015-04-09 23:06:39.837493	7	2	init	0	[]
55	专题一   如何“巧”解追击和相遇问题(三)	慢匀A在后，快减B在前。这种情况分两个阶段，阶段一：A、B共速之前，已慢A为参考系，快B远离A,二者间距在扩大；阶段二：AB共速之后，因为B减速，所以A速大于B速，以B为参考系，AB间距在缩短，所以AB共速时二者间距最大	58	DHCtRC6N0ekIeq8cwn892w	2015-02-27 14:00:29.447715	2015-04-09 23:06:39.843227	7	2	init	0	[]
56	第十三讲  专题一   如何“巧”解\v          追击和相遇问题(四)	\r\n（二）同向、同时、同起点。这种情况主要解决相遇几次的的问题。\r\n\r\n	59	D1w8eQPaEKY8jtRKxZb_OQ	2015-03-05 09:26:14.339995	2015-04-09 23:06:39.848966	7	2	init	0	[]
59	对法拉弟电磁感应定律的理解	这节课主要从法拉弟电磁感应定律的定义出发介绍了利用定义求感应电动势的三种方法。	62	u-sbj4_nMmMbNejOT7T8Fw	2015-03-18 14:05:46.660688	2015-04-09 23:06:39.862039	26	164	init	0	[]
60	追击相遇专题1	这 节课我们主要介绍了追击相遇的关键问题和常见的两种追击相遇中极值的处理方法。	63	RDcFUi9TsRLb8gY3Ze9Quw	2015-03-21 12:20:59.867322	2015-04-09 23:06:39.869368	26	161	init	0	[]
61	追击相遇专题2	这节课我们主要介绍了用物理分析的方法解追击相遇问题的方法	63	_bdRg-Tyxwo6sT_wA9DSbQ	2015-03-21 12:22:47.3264	2015-04-09 23:06:39.876681	26	161	init	0	[]
62	追击相遇专题3	这节课我们主要介绍了一种用数学的方法解追击相遇问题的方法	63	weuqq9Zlcl0hQ7yleOYFiw	2015-03-21 12:24:33.014074	2015-04-09 23:06:39.885763	26	161	init	0	[]
63	追击相遇专题4	这节课我们主要介绍了用运动相对性解追击相遇问题的方法	63	TG21lgreKQueiHTV6OYRNQ	2015-03-21 12:25:58.313321	2015-04-09 23:06:39.89502	26	161	init	0	[]
64	追击相遇专题5	这节课主要介绍了两种典型的追击相遇问题的极值问题	63	KYG1F-4rX70KUCJk-dtrAQ	2015-03-21 12:39:39.62942	2015-04-09 23:06:39.902295	26	161	init	0	[]
65	追击相遇专题6	这节课我们主要介绍了两个匀减速的物体的追击相遇问题	63	WVsbJfMtDxW0NCfA4kXedA	2015-03-21 12:41:03.201783	2015-04-09 23:06:39.90992	26	161	init	0	[]
66	追击相遇专题7	这节课我们主要讲了一道追击相遇习题的解法	63	UmxglqMN13nSpE3cy9-LPQ	2015-03-21 12:42:27.018797	2015-04-09 23:06:39.91755	26	161	init	0	[]
67	“边角互化”解决三角形问题	“边角互化”解决三角形问题	64	EZggawSmqmyupWuQuLBuhQ	2015-03-22 14:27:21.940321	2015-04-09 23:06:39.924683	24	145	init	0	[]
68	第十五讲  皮带专题（一）-----如何求解物体在皮带上的运动时间	例1、   如图所示，长为L=6.25m的水平传送带以速度v1=5m/s匀速运动，质量均为m的小物体P、Q由通过定滑轮且不可伸长的轻绳相连，某时刻P在传送带左端具有向右的速度v2=8m/s，P与定滑轮间的绳水平，P与传送带间的动摩擦因数为μ=0.2，重力加速度g=10m/s2，不计定滑轮质量和摩擦，绳足够长。求：\r\n（1）P物体刚开始在传送带上运动的加速度大小;\r\n（2）P物体在传送带上运动的时间。\r\n	65	GikGi9VTS017vmj1__k-zA	2015-03-22 14:54:02.238568	2015-04-09 23:06:39.930773	7	2	init	0	[]
69	v----t图象专题1	这节课主要从几方面介绍了速度时间图象的基本特点	66	bNoNuZxbwwFyBTvrBxM-_Q	2015-03-23 04:14:53.698437	2015-04-09 23:06:39.937969	26	161	init	0	[]
1	测试视频，用于测试第一个视频的发布	该视频主要讲了我们的主题，方法，思路以及后面的发展方式。	1	38ytlBkSBfCGnvE3TPFBUg	2014-06-25 12:39:29.728836	2015-04-09 23:06:39.54786	2	1	init	0	[]
13	dsfsdf	每个知识点都是一段视频。每段视频不要超过5分钟。 一个课程 所谓知识点要以"干"货为主，解决学生在解题考试中最容易遇到的问题， 易错点的分析、习题课、试卷讲解、等等。知识点的创建是在课程创建之后进行的。\r\n课程状态 这个选项是控制是否把课程开放给学生。 课程一开始创建的时候是没有知识点的（但是已经有价格了），如果直接开放给学生学生看不到任何知识点，会引起误解， 所以这个时候建议把课程状态	9	H4JbAYwlY3rCG_4UFt94ZA	2014-06-28 00:55:36.657369	2015-04-09 23:06:39.626374	2	1	init	0	[]
72	v----t图象专题4	这节课主要介绍了通过物体的速度时间图象考察物体的受力情况的问题的处理方法	66	VPXSSQO7rAYm6YWgDoFRug	2015-03-23 04:30:42.249624	2015-04-09 23:06:39.767235	26	161	init	0	[]
43	第七讲  v-t图像、x-t图像的识读技巧	在高中物理中有许多图像，同学们感到很头疼或负担重。其实物理图像的出现，不是为了学图像而学图像，即额外增加同学们的负担，而是为了帮助同学们将抽象的物理问题形象化，是用数学方法----图像法处理物理问题的一种方法或手段。同学们不仅要学会识图，更要学会应用。这样不仅会帮助同学们正确理解题意，而且会使解题更加简单快捷，希望同学们重视并灵活地掌握这种方法---图像法。\r\n	45	b185eeMMCbR3q6vgdjstZg	2014-11-29 14:17:42.286707	2015-04-09 23:06:39.780312	7	2	init	0	[]
70	v----t图象专题2	这节课主要介绍了在一个座标系中表示两个物体的运动的图象特点	66	sf4STXJ7pQqiPZpujlFnAQ	2015-03-23 04:16:11.154411	2015-04-09 23:06:39.94521	26	161	init	0	[]
71	v----t图象专题3	这节课主要介绍了通过单个物体的速度时间图象考察直线运动的方法	66	eW_HRIorXvlKsJOXdmAYEg	2015-03-23 04:28:58.503704	2015-04-09 23:06:39.952283	26	161	init	0	[]
73	v----t图象专题5	这节课主要介绍了通过物体的速度时间图象考察追击相遇问题的解决方法	66	Z1s1xAPDxd33X_8uAhUPeg	2015-03-23 04:32:24.254032	2015-04-09 23:06:39.959548	26	161	init	0	[]
77	第十六讲 如 何 正 确 理 解 和 解 答力的合成与分解问题	第十六	67	l_6WewDOPg-qgIUlHRcPGA	2015-03-24 05:23:03.006026	2015-04-09 23:06:39.965817	7	2	init	0	[]
80	第十七讲 皮带专题（二）-----如何求解物体在倾斜皮带上的运动时间	第十七讲 皮带专题（二）-----如何求解物体在倾斜皮带上的运动时间	68	POjwfhaMk_QKkD9vJ5muCg	2015-03-29 15:00:00.869111	2015-04-09 23:06:39.972043	7	2	init	0	[]
74	v----t图象专题6	这节课我们主要介绍了通过两个物体的速度时间图象考察追击相遇问题的解法	66	wcVjWbsok4cx-9h3nh6-6w	2015-03-23 04:33:51.901261	2015-04-09 23:06:39.979515	26	161	init	0	[]
83	第十八讲  总结和扩充 小船过河模型的常用物理量	典例　小船在200 m宽的河口横渡，水流速度为3 m/s，船在静水中的航速是5 m/s，求：\r\n(1)当小船的船头始终正对对岸行驶时，它将在何时、何处到达对岸？\r\n(2)要使小船到达河的正对岸，应如何行驶？多长时间能到达对岸？(sin37°＝0.6)\r\n　 \r\n	70	FqRgt_iCtmPqmQaNXHNwow	2015-04-04 05:46:44.680707	2015-04-09 23:06:39.986967	7	3	init	0	[]
75	v----t图象专题7	这节课我们主要介绍了通过速度时间图象考察传送带问题的解法	66	jwbHNsIoOQX0MTApV6i8Uw	2015-03-23 04:36:18.456588	2015-04-09 23:06:39.993935	26	161	init	0	[]
76	v----t图象专题8	这节课我们主要介绍了通过速度时间图象考察追击相遇问题的解法	66	-0hhGfs0T6NaimeEGTogaQ	2015-03-23 04:37:29.981548	2015-04-09 23:06:40.00257	26	161	init	0	[]
85	第十九讲  如何判断和求解平抛运动的抛出点的坐标	如何判断和求解平抛运动的抛出点的坐标是平抛运动的一个难点，同学们有一个固定思维，坐标原点永远和抛出点对应，其实不然..	72	cE-mHNjb69obIlFAI7FBlw	2015-04-06 10:16:45.569437	2015-04-09 23:06:40.027126	7	3	init	0	[]
89	7.1.4物体间力的作用是相互的	关于力的作用是相互的概念的理解，总结一对相互作用的力的特点，对物体间力的作用是相互的相关试题进行练习及讲解。	73	E4g3ZliZFMUkWyrhbSYcCg	2015-04-12 02:45:11.617848	2015-04-12 02:45:20.566592	59	282	reviewing	0	[]
86	7.1.1力的作用效果	通过实验和现象了解力的作用效果，并能够进行判断，对力的作用效果的相关问题进行练习和讲解。	73	kQhQVsidyYgy01047B83OQ	2015-04-12 02:30:01.127982	2015-04-12 02:38:25.079632	59	282	rejected	0	[]
87	7.1.2力的三要素	通过实验探究影响力的作用效果的三要素，对力的三要素的相关问题进行练习和讲解。	73	hDFRUSZ1GzKobcODcLi4rA	2015-04-12 02:33:56.939395	2015-04-12 02:39:30.515738	59	282	rejected	0	[]
88	7.1.3力的示意图	力的示意图的画法，对于力的示意图的相关问题进行练习和讲解。	73	QtBsRwhIhj2G2CZsx0V3mQ	2015-04-12 02:40:22.323813	2015-04-12 02:44:58.186662	59	282	rejected	0	[]
94	第二十讲 圆周运动专题（一）------求解圆周运动的 基 本 步 骤	1、确定研究对象；\r\n2、确定研究对象所在的圆周运动的\r\n     平面----找圆心、确定半径；\r\n	74	A8HEtrsa7vZmd_e8vHgDcg	2015-04-13 13:56:17.13724	2015-04-13 13:56:17.13724	7	3	editing	0	[]
95	    @video_player_id = rand(10000)    @video_player_id = rand(10000)    @video_player_id = rand(10000)    @video_player_id = rand(10000)	    @video_player_id = rand(10000)试试\r\n    @video_player_id = rand(10000)\r\n    @video_player_id = rand(10000)\r\n    @video_player_id = rand(10000)\r\n    @video_player_id = rand(10000)\r\n    @video_player_id = rand(10000)\r\n    @video_player_id = rand(10000)\r\n	78	VpytTdUcNPjt_2fF__MSbw	2015-04-15 10:37:13.896195	2015-04-18 23:45:12.230572	65	302	published	0	[]
115	asdfasdfasdf	asdfasdfasdf	19	3H6qEZIlp98KyIxEHA56gw	2015-04-29 22:02:39.323933	2015-04-29 22:02:39.323933	2	1	editing	0	[]
116	wait_convertwait_convertwait_convertwait_convert	wait_convertwait_convertwait_convertwait_convertwait_convert	19	wvjbiyVtfNFiTW44U1JxUA	2015-04-29 22:04:10.968054	2015-04-29 22:04:10.968054	2	1	editing	0	[]
153	okokoko	okokoko\r\nokokoko\r\nokokoko\r\n	13	BFIK8-XjY-_gWqjDthqeXQ	2015-04-30 02:27:46.512989	2015-04-30 02:27:46.512989	2	1	editing	0	[]
154	asdfasdfads	12341234123412	19	vRZ80KpafxuSb1vtN9GV6Q	2015-04-30 03:55:16.422972	2015-04-30 03:55:16.422972	2	1	editing	0	[]
156	没有声音看看一会儿能不能好	没有声音看看一会儿能不能好没有声音看看一会儿能不能好	13	vlHF_OAcNxG_afkwPr7jSQ	2015-05-02 05:59:11.984856	2015-05-02 05:59:11.984856	2	1	editing	0	[]
158	测试看看有没有声音	测试看看有没有声音测试看看有没有声音测试看看有没有声音测试看看有没有声音	19	VpwDVmvMOFh9Dq2rDd1jIg	2015-05-02 08:57:22.354405	2015-05-02 08:57:22.354405	2	1	editing	0	[]
157	试试重定向是否ok	试试重定向是否ok\r\n试试重定向是否ok	13	6SPFQGL_FWFWdoW77CPygQ	2015-05-02 06:11:08.236927	2015-05-18 11:57:00.658272	2	1	rejected	0	[]
81	第十八讲   总结和扩充 小船过河模型的常用物理量	二、典例　小船在200 m宽的河口横渡，水流速度为3 m/s，船在静水中的航速是5 m/s，求：\r\n(1)当小船的船头始终正对对岸行驶时，它将在何时、何处到达对岸？\r\n(2)要使小船到达河的正对岸，应如何行驶？多长时间能到	69	9WadxJT75gVWao0AH_hhuA	2015-04-03 15:04:32.342534	2015-04-09 23:06:40.011321	7	3	init	1	[]
99	sdfasfasdfasdfa	123143123412341234	19	8l480XYMBvHNFLlXWWPRYw	2015-04-27 23:00:56.710645	2015-04-27 23:00:56.710645	2	1	editing	0	[]
82	第十八讲   总结和扩充 小船过河模型的常用物理量	二、典例　小船在200 m宽的河口横渡，水流速度为3 m/s，船在静水中的航速是5 m/s，求：\r\n(1)当小船的船头始终正对对岸行驶时，它将在何时、何处到达对岸？\r\n(2)要使小船到达河的正对岸，应如何行驶？多长时间能到	69	9WadxJT75gVWao0AH_hhuA	2015-04-03 15:04:37.561986	2015-04-09 23:06:40.019036	7	3	init	0	[]
100	高考中力学选择题分类讲解	232 测试以下视频装哈u的232 测试以下视频装哈u的232 测试以下视频装哈u的	80	0i2S7ZeHbXj-fopCMe3QCw	2015-04-28 22:06:04.578184	2015-06-02 21:57:01.33722	2	323	editing	0	["", "应试技巧", "高考重点"]
97	这个是一个用于展示的视频，用于测试	课程简介最好写的丰富一点用于给学生进行介绍。测试	80	4C4THzVhdvf0567kCcw89g	2015-04-22 23:27:50.951737	2015-06-02 21:55:45.592987	2	323	editing	2	["", "常见问题", "期中考试重点", "会考重点"]
58	第十四讲    专题一   如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例	专题一   如何“巧”解追击和相遇问题(五)——巧 选 参 考 系 的 典 型 范 例\r\n	61	NfbwXVgmA3S3J6IFNay-5g	2015-03-11 16:31:53.906101	2015-04-09 23:06:39.855004	7	2	init	0	[]
161	asdfasdfasdfasdfasdfasdfasdfasfsfadfasdf	asdfasfasdfasdf1234123412341213412341	82	gFlR2FC7rEHdKLwcM03r4g	2015-05-31 00:09:07.663293	2015-05-31 00:09:07.663293	2	322	editing	0	["", "解题方法与思路", "易错点分析"]
152	okoko 测试以下么哈哈到底长度长了是个什么样子需要看下啊okoko 测试以下么哈哈到底长度长了是个什么样子需要看下啊okoko 测试以下么哈哈到底长度长了是个什么样子需要看下啊	okokoko	13	gSrT95oBhZpt3jwN7vCHJg	2015-04-30 02:22:36.131788	2015-05-31 03:35:47.600806	2	1	editing	0	["", "知识点讲解", "解题方法与思路", "常见问题", "易错点分析", "期中考试重点", "期末考试重点", "应试技巧", "会考重点", "高考重点"]
114	    video.convert_transition    video.convert_transition    video.convert_transition	    video.convert_transition\r\n    video.convert_transition\r\n    video.convert_transition\r\n    video.convert_transition\r\n	19	rGpfMhTr0s6-L22GU2bimA	2015-04-29 21:58:43.679142	2015-05-31 09:07:11.254962	2	1	editing	0	["", "常见问题", "易错点分析"]
159	力学易错题分析一	测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢测试课程谢谢	80	V5d_rZVG5bmgQA2GsaX9Mw	2015-05-29 14:58:21.042755	2015-06-02 21:57:38.014106	2	323	editing	1	["", "易错点分析"]
163	测试测试测试	测试测试测试	13	ca8xW4RkRThTqrbhLmqBzg	2015-06-16 21:45:24.595959	2015-06-16 21:45:24.595959	2	1	editing	0	[""]
162	asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好	asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好asdfasd你好	13	H6Nu6Dszxbq9qvYpCl8vXw	2015-06-01 22:25:09.935893	2015-06-16 21:57:22.033747	2	1	reviewing	0	[""]
\.


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('lessons_id_seq', 164, true);


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY messages (id, sender_id, receiver_id, message_type, status, content, created_at, updated_at) FROM stdin;
\.


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('messages_id_seq', 1, false);


--
-- Data for Name: nodes; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY nodes (id, name, summary, topics_count, created_at, updated_at, section_id, tutorials_count, courses_count, en_name) FROM stdin;
\.


--
-- Name: nodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('nodes_id_seq', 1, false);


--
-- Data for Name: pictures; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY pictures (id, name, imageable_id, imageable_type, created_at, updated_at, token) FROM stdin;
1	41bc3e59eb5043d63233ec971c8a1c81.JPG	1	Topic	2014-06-25 13:19:54.654593	2014-06-25 13:20:14.965668	AfRwSUqJWSXEk2vk0tQmZQ
2	405da9842bff6165d20be4a6570aa4ae.JPG	\N	\N	2014-06-25 14:55:17.634943	2014-06-25 14:55:17.634943	
3	48694c49eeb403aabc88ed4db8c1c52d.jpg	\N	\N	2014-08-04 14:33:16.285861	2014-08-04 14:33:16.285861	AjLqOoJFzERMyn8U1bNyaA
4	c1330b98a4a7547287be632714da8b94.jpg	\N	\N	2014-08-04 14:51:55.592083	2014-08-04 14:51:55.592083	AjLqOoJFzERMyn8U1bNyaA
5	dc9ef5def6a3a4855cb0b3fa8a2ae802.jpg	\N	\N	2014-08-04 14:56:52.659685	2014-08-04 14:56:52.659685	AjLqOoJFzERMyn8U1bNyaA
6	cca143c63e5c45e5ce4ea12afa17be72.jpg	\N	\N	2014-08-04 14:59:27.686932	2014-08-04 14:59:27.686932	AjLqOoJFzERMyn8U1bNyaA
7	53f172d8ffda00d85768423eff8ca94c.jpg	\N	\N	2014-08-04 15:44:50.883076	2014-08-04 15:44:50.883076	2ZKCr4BrQtMl6mlJn5xB1w
8	ef84a7bf35c9d3e382c3568c6509f36d.jpg	\N	\N	2014-08-04 15:48:06.792902	2014-08-04 15:48:06.792902	2ZKCr4BrQtMl6mlJn5xB1w
9	a9e01115c10fb921f2d490e338bd3325.jpg	\N	\N	2014-08-04 15:51:40.340178	2014-08-04 15:51:40.340178	2ZKCr4BrQtMl6mlJn5xB1w
10	d4a669914ae71a25ab9f038af79be8c1.jpg	\N	\N	2014-08-05 13:43:51.734496	2014-08-05 13:43:51.734496	S4yn1DVDa9M27cW1YNTlag
11	6e6fcc9394e20af5eaa139d7c5dab746.png	\N	undefined	2015-04-19 05:08:31.042178	2015-04-19 05:08:31.042178	undefined
12	a6cec2afacc01930940e7ec277cac85f.jpg	\N	QaFaq	2015-04-22 03:35:15.602738	2015-04-22 03:35:15.602738	F5900g8Hr9TUGKKnrF1Ebg
50	304b01984cd9f0f0bbb039ddde0487fe.png	18	Answer	2015-08-27 05:35:11.678885	2015-08-27 05:35:11.678885	1440653689-OyKOkuPa-gKtFRKTrFi9VA
13	496b6886290b828dca80202fd7a27cb0.jpg	4	QaFaq	2015-04-22 03:36:24.814876	2015-04-22 03:36:24.814876	mb_ZZpdtmILNE-EhN6hZww
14	99698593cd41ed90a7782851488c8057.jpg	\N	QaFaq	2015-04-22 03:39:07.575565	2015-04-22 03:39:07.575565	mb_ZZpdtmILNE-EhN6hZww
15	59bc180d4f1bbe24862eacfa9c550e95.png	\N	\N	2015-05-23 04:03:04.376276	2015-05-23 04:03:04.376276	1432353679-UThtpGaEfDvgy4jaFt-3HQ
16	c9b73c74518690cd65d1b7dc0cb6872a.png	\N	\N	2015-05-23 23:07:28.809115	2015-05-23 23:07:28.809115	1432422425-EjBPZCd4h-EoaJ6np-BTFg
17	ae927e81ad18c747ed9e20422a7c3e2b.png	\N	\N	2015-05-23 23:07:44.969969	2015-05-23 23:07:44.969969	1432422425-EjBPZCd4h-EoaJ6np-BTFg
56	6763a38925fbcf76b4acbf6091fbdbf8.png	21	Answer	2015-08-27 06:11:04.79312	2015-08-27 06:11:04.79312	1440655852-ZaLhc_MrOd-2qDNuABfTyA
53	b60c48eaef35b45ba5a75bf6e0ffff0f.png	19	Answer	2015-08-27 06:07:19.487872	2015-08-27 06:07:19.487872	1440655628-LuqaKi7mEkmMHnyKuwNH7Q
20	de54776459cca10e612c53cf726d3bd1.png	\N	Topic	2015-05-24 02:57:29.717942	2015-05-24 02:57:29.717942	1432436238-oshkDZBu1OJ5toM1vhq5cg
21	783c9e0598c3f55603297e7d3709aeb0.png	\N	Topic	2015-05-25 09:52:00.87221	2015-05-25 09:52:00.87221	1432547512-mUlpSXyIsWFZNKQEXrwPfw
23	b1eb105c016975ed63b36c0355b60809.png	\N	Topic	2015-05-26 23:37:43.245369	2015-05-26 23:37:43.245369	1432683449-WYhgWN6FFJduusA3f3_bqw
24	bfed5ef9a941c9fb2bf886f389fe1a27.png	\N	Reply	2015-05-26 23:41:56.042251	2015-05-26 23:41:56.042251	1432683706-SIsAOp35kyUQsKyseG8jKw
25	ef5e7ed54e1eabc3dffcd1d4bedd9122.PNG	\N	\N	2015-08-27 01:51:36.544472	2015-08-27 01:51:36.544472	1440640263-rgwoBvJTrxR1iExkzqcURg
26	031e3f84e6368c2641c2b7f5e29b87a7.PNG	\N	\N	2015-08-27 01:54:46.211484	2015-08-27 01:54:46.211484	1440640472-3l6Z59Drz6fhi_dYeLXaBQ
27	612388eb318b09bd4102132c11ad0209.jpg	\N	\N	2015-08-27 01:55:51.196783	2015-08-27 01:55:51.196783	1440640520-4fzVuKI1bDGoVu1LExELyQ
28	75423c294dc7ef645db1b108ae2bd1cd.jpg	\N	\N	2015-08-27 01:56:54.205398	2015-08-27 01:56:54.205398	1440640597-ZggP6pob5KjTB8n8cc5Azw
29	0126698f65c0306ac6f76efad87e8e2c.jpg	\N	\N	2015-08-27 01:57:21.408014	2015-08-27 01:57:21.408014	1440640625-woD_rQo-ghvakvAtbZYWZg
30	2487e53488b815b2c8e342b39145d792.jpg	\N	\N	2015-08-27 02:00:32.741414	2015-08-27 02:00:32.741414	1440640778-S-kfbdr4rmhit6xZTh2L7w
31	f3c7ffac47b0083fe2e16c0accb2910c.jpg	\N	\N	2015-08-27 02:00:59.863042	2015-08-27 02:00:59.863042	1440640842-xq5VRlzztFdbzP0hE6yCrA
32	d69e7dd0d027b3a93bd508b82ce5c306.jpg	\N	\N	2015-08-27 02:02:14.46208	2015-08-27 02:02:14.46208	1440640922-LSub8hvojbOraMKlLLG5DQ
33	280b7144aaa70fdf1d101f59628c027b.jpg	\N	\N	2015-08-27 02:02:54.350849	2015-08-27 02:02:54.350849	1440640961-TNkFJm7UfFRZ8AsLW9QvNg
34	07d1ef33c5bdcb841e3031b27a28159a.jpg	\N	\N	2015-08-27 02:03:15.816666	2015-08-27 02:03:15.816666	1440640978-l4qfNHThM7SA1rSqanKobQ
35	da313fe11f3947513ef936cf26493934.jpg	\N	\N	2015-08-27 03:01:22.717489	2015-08-27 03:01:22.717489	1440644467-0ZblXibq6Zeob99G6dz5zw
36	cd621505a45df455f11692f7ae78f6e9.jpg	\N	\N	2015-08-27 03:03:41.600295	2015-08-27 03:03:41.600295	1440644609-Al_08UwrDewbkLoZO9zutQ
37	e933cd6e7a8cb6d12db63bc8302849e6.jpg	\N	\N	2015-08-27 03:10:02.238976	2015-08-27 03:10:02.238976	1440644979-7pha311tJZtqbu7JoeQdQQ
38	cec1b7217bc42bdf4f61a2785f7ff097.png	\N	\N	2015-08-27 03:10:17.687284	2015-08-27 03:10:17.687284	1440644979-7pha311tJZtqbu7JoeQdQQ
39	c13563d96cbcaf2c0cc364b556035957.jpg	\N	\N	2015-08-27 03:10:35.771316	2015-08-27 03:10:35.771316	1440644979-7pha311tJZtqbu7JoeQdQQ
40	6b3d7316c51e1e56b46b554b70847d76.jpg	\N	\N	2015-08-27 03:22:42.398016	2015-08-27 03:22:42.398016	1440645746-a6JcOzzmRD2p0GFBQKYvNg
41	cf382de3d3eca384b9e28b16af6aa09f.png	\N	\N	2015-08-27 03:24:26.273638	2015-08-27 03:24:26.273638	1440645848-Fr8Hay28FJaSuR7umJsrBQ
42	68b29aaa3954efa8b44b8bb3145dd6ef.png	\N	\N	2015-08-27 03:25:21.075956	2015-08-27 03:25:21.075956	1440645903-GYYEbdmdYUv6anHK8WAkHA
43	f5a214596b64ec1e135dd3ac6b7214eb.png	\N	\N	2015-08-27 03:34:26.292297	2015-08-27 03:34:26.292297	1440646454-N38HItxvlyRrUSgJTcgUeg
44	daff3894f68c945d4d0c218abca93cf3.png	\N	\N	2015-08-27 03:36:44.007366	2015-08-27 03:36:44.007366	1440646584-s8j4e08mzHbthatvEGYb9Q
45	3b4f866e0d04360dac4ddc7971eebc9a.png	\N	\N	2015-08-27 03:38:01.097777	2015-08-27 03:38:01.097777	1440646661--xQE40ISv0R9S3E0tmNelw
46	70f7a7e5af991f957158dd4853b83b4e.png	17	Answer	2015-08-27 03:41:43.338757	2015-08-27 03:41:43.338757	1440646892-ADosWGP01djT1Jds8gDn6A
47	0519baca76fe958ef37a419894699389.jpg	\N	\N	2015-08-27 05:18:25.576669	2015-08-27 05:18:25.576669	1440652678-0nVjlG_ZUPhJMTpr9OsHoA
48	7f471c6ce8e61160345a109b47c8287f.png	\N	\N	2015-08-27 05:22:08.292168	2015-08-27 05:22:08.292168	1440652904-_S-HCvL-Z5H5YdLmlpipfw
49	e9889b33f6bc18bfd7b97770dc459796.png	\N	\N	2015-08-27 05:34:30.342419	2015-08-27 05:34:30.342419	1440653651-tf8TSjiOh1yORM6qufD3FQ
54	eabccd6a26a8a7b29c6be15889890995.png	20	Answer	2015-08-27 06:08:04.86826	2015-08-27 06:08:04.86826	1440655671-kQ5mkOspZCdqLdJvdfG2ag
55	0fe9685be3bb768b5817376c761e4c98.jpg	\N	\N	2015-08-27 06:10:13.494627	2015-08-27 06:10:13.494627	1440655795-uxuAlFk5wRQyhTfE4nzVXg
58	e5fa0b03b3faea9ac9bf9cc22ec2def4.png	23	Answer	2015-08-27 06:13:31.428331	2015-08-27 06:13:31.428331	1440655999-d2DDowtINX9fwJ02wS_K1A
57	31d4722355a0258aa8262fc71c52834d.png	22	Answer	2015-08-27 06:12:07.960977	2015-08-27 06:12:07.960977	1440655910-wlQur7z-nn6Vd2wM8YnBYQ
60	067d00ef8f304f5d7d5b2b6719f09f7e.png	38	Topic	2015-08-27 06:17:23.762496	2015-08-27 06:17:23.762496	1440656232-PYM9YH2Y5G_2jSFDwmubVA
59	fa471b1fa451294bac0802086f5fb120.jpg	23	Answer	2015-08-27 06:14:04.712189	2015-08-27 06:14:04.712189	1440655999-d2DDowtINX9fwJ02wS_K1A
61	4bb544e8a85cb857f47cfb4ac2fe7fee.png	23	Question	2015-08-27 10:48:50.193436	2015-08-27 10:48:50.193436	1440672515-b5SpADKWLLgZWVDS2BlHhQ
62	6e1f7d9f34cae03042f6720bd84c0482.jpg	\N	\N	2015-08-27 10:51:06.602382	2015-08-27 10:51:06.602382	1440672654-Mm4g9pYW0998aLanCEUD_Q
63	7d43385fe140457e0d2aa86425c4d2cf.jpg	\N	\N	2015-08-27 11:12:59.952977	2015-08-27 11:12:59.952977	1440673966-zBNj6SIJxk9cfggtW-MS8Q
64	84c6cadecdd4a20f2e062594bd911b3d.jpg	\N	\N	2015-08-27 11:13:24.920031	2015-08-27 11:13:24.920031	1440673991-IL86DUd3cpTTxGeMiOuVuw
65	7745be834f9f4e0435dc092182961dbe.jpg	\N	\N	2015-08-27 11:14:53.527945	2015-08-27 11:14:53.527945	1440674079-Unh697vs2LUKa4vlp7UUiw
66	402fe794b081a8e8b23452c5be1848d9.png	\N	\N	2015-08-27 11:15:04.745795	2015-08-27 11:15:04.745795	1440674079-Unh697vs2LUKa4vlp7UUiw
67	ad6a605a4f5e789f52a708f0d80fed92.jpg	\N	\N	2015-08-27 11:15:20.351326	2015-08-27 11:15:20.351326	1440674079-Unh697vs2LUKa4vlp7UUiw
68	8607cef25fd7bdc01a6a6eeb7591e734.jpg	24	Question	2015-08-27 11:16:27.515944	2015-08-27 11:16:27.515944	1440674167-ysVWesCusYQ8iv5sSVKAOA
69	d11d040ba6e7e180b00c2577c434bc4e.jpg	24	Question	2015-08-27 11:16:40.173765	2015-08-27 11:16:40.173765	1440674167-ysVWesCusYQ8iv5sSVKAOA
70	7e113c67ac880b1d7f8b082dfaf9bbc0.jpg	24	Question	2015-08-27 11:16:54.222076	2015-08-27 11:16:54.222076	1440674167-ysVWesCusYQ8iv5sSVKAOA
71	430e7a421d074b9c84f577b42bd3cf76.jpg	24	Question	2015-08-27 11:17:11.011418	2015-08-27 11:17:11.011418	1440674167-ysVWesCusYQ8iv5sSVKAOA
72	0d759e138c1e8164359c3952541f1b4e.jpg	24	Question	2015-08-27 11:18:16.453836	2015-08-27 11:18:16.453836	1440674167-ysVWesCusYQ8iv5sSVKAOA
73	55e0efab65c0da5b9fdd1b9609b28599.jpg	24	Question	2015-08-27 11:18:28.934767	2015-08-27 11:18:28.934767	1440674167-ysVWesCusYQ8iv5sSVKAOA
74	cf08b4fe622fec43b710cb81da502b81.jpg	24	Question	2015-08-27 11:18:39.470931	2015-08-27 11:18:39.470931	1440674167-ysVWesCusYQ8iv5sSVKAOA
75	79ecb7ca492e1e0a3b48143cb01911da.jpg	24	Question	2015-08-27 11:18:51.636144	2015-08-27 11:18:51.636144	1440674167-ysVWesCusYQ8iv5sSVKAOA
76	04117b1c43043ad8db23547863ae79bf.jpg	24	Question	2015-08-27 11:19:05.799445	2015-08-27 11:19:05.799445	1440674167-ysVWesCusYQ8iv5sSVKAOA
82	0da3a6ce64e8d05b8c4357f700084cc9.jpg	\N	\N	2015-09-08 06:54:22.488839	2015-09-08 06:54:22.488839	
83	196b15a79490b8bf423b483079d73d83.jpg	\N	\N	2015-09-08 06:58:19.537769	2015-09-08 06:58:19.537769	1441695478-6ZZEev75ICYmE3aCq55vZg
84	dd26bf998f36a1dc06e6460f9cba7f72.jpg	\N	\N	2015-09-08 10:02:27.977669	2015-09-08 10:02:27.977669	1441706436-NYUlK9m0zbXZXth2J_bKrA
93	c582eeb5d14132ddc23d9f7d62f94692.jpg	7	Homework	2015-09-09 08:21:44.506494	2015-09-09 08:21:44.506494	1441786862-TXXJTBgX3z3wM7A08tbNhA
91	aa5730af43a434c7a69ede693275bc9a.jpg	5	Homework	2015-09-09 05:16:12.984031	2015-09-09 05:16:12.984031	1441775528-6Nb6fjRAfp1CiLvgmEbQ_Q
94	d724a90ac2cd83d1e07bb1fef2d65871.jpg	\N	\N	2015-09-17 09:43:43.74103	2015-09-17 09:43:43.74103	1442483004-y_0iYEz_ScqX9svsC9YR0g
92	844d7641e00de06e8ceb38beb019ffc7.jpg	6	Homework	2015-09-09 08:17:40.105309	2015-09-09 08:17:40.105309	1441786642-8TGfNHzEKEneBstzanC_IA
77	5b89dd0aa598e8f80ea36feb87798fef.jpg	39	Topic	2015-08-27 11:36:04.267016	2015-08-27 11:36:04.267016	1440675344-vKR-YewaruJ98k3t_YFXWA
78	e995159f2e9aa7abd5fba769081ff198.jpg	39	Topic	2015-08-27 11:36:23.614343	2015-08-27 11:36:23.614343	1440675344-vKR-YewaruJ98k3t_YFXWA
79	210e63c78d5b678bcc1b9f1009fc073c.jpg	39	Topic	2015-08-27 11:36:51.616341	2015-08-27 11:36:51.616341	1440675344-vKR-YewaruJ98k3t_YFXWA
80	56149671c310266b7bc2ad2d389cbb73.jpg	39	Topic	2015-08-27 11:37:08.695421	2015-08-27 11:37:08.695421	1440675344-vKR-YewaruJ98k3t_YFXWA
81	a4ee401083a7dd131f91246dba205a74.jpg	40	Topic	2015-08-27 11:38:34.523926	2015-08-27 11:38:34.523926	1440675486-QhWSTd5Rey70uNF7RYZUxQ
95	7ec42e452a44030847fef64967b5a2d2.png	58	TutorialIssueReply	2015-10-11 08:31:30.294417	2015-10-11 08:31:30.294417	1444552234-VVwmnatHLS30m_McjPVXVg
96	4a937a6cf774f2be46de134a2a9861f3.png	63	Reply	2015-10-11 12:36:34.675294	2015-10-11 12:36:34.675294	1444566036-QZGXWgm6JxCJ4CsGjnqNmQ
97	8a6923d96beca9712f37486d15332483.png	64	TutorialIssueReply	2015-10-11 12:37:12.215529	2015-10-11 12:37:12.215529	1444566822-PUTCXnD7HlhEPe4VoaaZog
98	375aa448e838af825e46eeb782df196b.png	69	Reply	2015-10-11 13:40:32.102066	2015-10-11 13:40:32.102066	1444568311-ClHMTEbKd-ZyGgSEDA1Wpw
99	2cb084d5b42a85f51d3c3d2ac885cf9e.png	69	Reply	2015-10-11 13:42:00.900121	2015-10-11 13:42:00.900121	1444568311-ClHMTEbKd-ZyGgSEDA1Wpw
100	536ca2d384e7c8c1b3e58d71ae42e05d.png	70	Reply	2015-10-11 13:43:07.367092	2015-10-11 13:43:07.367092	1444570943-C8COxlKve4URoHmx8TP0zw
101	87349fa9d1dc15ccc60826b2092cad10.JPG	21	Examination	2015-10-21 00:19:27.265011	2015-10-21 00:19:27.265011	1445386591-Rhz0bUuCA4b35s_tdPnb8Q
\.


--
-- Name: pictures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('pictures_id_seq', 101, true);


--
-- Data for Name: qa_faqs; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY qa_faqs (id, title, content, qa_faq_type, created_at, updated_at, token) FROM stdin;
1	这个东西很操蛋这个东西很操蛋	<p>这个东西很操蛋</p><p><br><img style="width: 465px; height: 348.6133960047px;" src="data:image/png;base64,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" data-filename="QQ截图20150417213926.png"></p>	1	2015-04-19 07:22:47.31209	2015-04-19 07:22:47.31209	\N
2	这个东西很操蛋这个东西很操蛋	<p>这个东西很操蛋</p><p><br><img style="width: 465px; height: 348.6133960047px;" src="data:image/png;base64,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" data-filename="QQ截图20150417213926.png"></p>	1	2015-04-19 08:20:10.72948	2015-04-19 08:20:10.72948	\N
3	测试下看看	哈哈哈到底是可以了么	2	2015-04-19 09:12:10.591462	2015-04-19 09:12:10.591462	\N
4	asdfasdf	<p><br>sss</p>	0	2015-04-22 03:36:38.790269	2015-04-22 03:38:54.887529	mb_ZZpdtmILNE-EhN6hZww
\.


--
-- Name: qa_faqs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('qa_faqs_id_seq', 4, true);


--
-- Data for Name: qa_files; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY qa_files (id, author_id, qa_fileable_id, qa_fileable_type, name, qa_file_type, created_at, updated_at, original_filename) FROM stdin;
15	75	6	Solution	dac4e458a48c84f2df6643bd3e1448ce.doc	application/msword	2015-09-24 22:28:42.753218	2015-09-24 22:28:42.753218	3eec6fda658d31a4688450f9ded73262.doc
19	76	21	Examination	ddde6c0d05f35b9d1bd70bd1b7121191.doc	application/msword	2015-10-21 00:19:47.676933	2015-10-21 00:19:47.676933	3eec6fda658d31a4688450f9ded73262 (1).doc
14	2	10	Examination	bc013dcbeb0342672c7726ce2f424721.jpg	image/jpeg	2015-09-22 06:39:07.209857	2015-10-06 08:48:00.018047	c207559d9050981d467d45b284402d13.jpg
16	2	15	Examination	f1ed4c06905fce703d0239ea9aab6319.png	image/png	2015-10-07 04:58:32.401049	2015-10-07 04:58:32.401049	1584e12248a7e6421ce334ad0c0119eb.png
17	2	16	Examination	d4f0944daf2dc4ab1e941ab107737e26.png	image/png	2015-10-07 06:00:49.050575	2015-10-07 06:00:49.050575	企业真实性核验单 (1).png
18	2	17	Examination	e825a565bb241e6aed404cf065d39df9.png	image/png	2015-10-07 06:02:10.032332	2015-10-07 06:02:10.032332	企业真实性核验单 (1).png
10	2	5	Examination	c98a6aee7335e15da80cae477a25a59a.html	text/html	2015-09-09 05:16:42.475995	2015-09-09 05:16:42.475995	1.html
11	2	6	Examination	dbf1aef3a8c215db8c414641bcde0d1b.html	text/html	2015-09-09 08:18:06.746205	2015-09-09 08:18:06.746205	1.html
12	2	6	Examination	7906cb1655fc9f37e60e77162cb149cb.png	image/png	2015-09-09 08:18:06.869484	2015-09-09 08:18:06.869484	屏幕快照 2015-08-07 下午4.56.36.png
13	2	7	Examination	9b11dac019328cb6ca586c2d7e6ae570.jpg	image/jpeg	2015-09-09 08:21:52.955019	2015-09-09 08:21:52.955019	frame.jpg
21	75	15	Solution	5396a7350cc6f116d040da7a02e16bcf.JPG	image/jpeg	2015-10-21 21:43:47.861261	2015-10-21 21:43:47.861261	IMG_8038.JPG
\.


--
-- Name: qa_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('qa_files_id_seq', 21, true);


--
-- Data for Name: question_assignments; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY question_assignments (id, question_id, teacher_id, created_at, updated_at) FROM stdin;
1	21	2	2015-08-24 07:44:49.387212	2015-08-24 07:44:49.387212
2	22	2	2015-08-24 07:44:49.436218	2015-08-24 07:44:49.436218
3	23	2	2015-08-27 10:49:06.997285	2015-08-27 10:49:06.997285
4	24	2	2015-08-27 11:19:27.124145	2015-08-27 11:19:27.124145
\.


--
-- Name: question_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('question_assignments_id_seq', 4, true);


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY questions (id, title, content, token, student_id, answers_count, vip_class_id, learning_plan_id, answers_info, last_answer_info, created_at, updated_at, comments_count) FROM stdin;
21	关于动量守恒有多少种题型，能否给讲解一下？	关于栋梁守恒有多少种题型，这些题型都是如何解，请老师给讲解下。	1431948275-RF9MvM2pE2O4BpoUOOxzDw	75	0	2	24	{"2": false}	{}	2015-05-18 11:25:56.040443	2015-08-24 05:59:46.515891	0
24	测试以下么啊啊啊啊嗄啊啊啊啊	<p><br><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/8607cef25fd7bdc01a6a6eeb7591e734.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/d11d040ba6e7e180b00c2577c434bc4e.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/7e113c67ac880b1d7f8b082dfaf9bbc0.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/430e7a421d074b9c84f577b42bd3cf76.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/0d759e138c1e8164359c3952541f1b4e.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/55e0efab65c0da5b9fdd1b9609b28599.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/cf08b4fe622fec43b710cb81da502b81.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/79ecb7ca492e1e0a3b48143cb01911da.jpg"><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/04117b1c43043ad8db23547863ae79bf.jpg"></p>	1440674167-ysVWesCusYQ8iv5sSVKAOA	75	0	2	24	{}	{}	2015-08-27 11:19:27.114034	2015-08-27 11:19:27.114034	2
22	追击问题应该如何解决呢？这类问题太复杂啦	追击问题应该如何解决，追击问题的解决思路有哪些？	1431948548-mE58MYO00xzV5ZLMjvZjhQ	75	7	2	24	{"2": false}	{}	2015-05-18 11:30:32.227465	2015-08-24 05:59:46.584587	0
23	测试以一下啦测试以一下啦测试以一下啦测试以一下啦测试以一下啦测试以一下啦	<p><br><img style="width: 754px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/4bb544e8a85cb857f47cfb4ac2fe7fee.png"></p>	1440672515-b5SpADKWLLgZWVDS2BlHhQ	75	0	2	24	{}	{}	2015-08-27 10:49:06.98492	2015-08-27 10:49:06.98492	0
\.


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('questions_id_seq', 24, true);


--
-- Data for Name: recharge_codes; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY recharge_codes (id, money, code, admin_id, "desc", created_at, updated_at, student_id, lock_version) FROM stdin;
1	500	nUq5/Z1Ggq966A99uMDvb6WcRWEVU6Ec	1	第一张充值卡	2014-06-25 12:42:19.297394	2014-06-25 12:42:39.240344	3	1
\.


--
-- Name: recharge_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('recharge_codes_id_seq', 2, false);


--
-- Data for Name: recharge_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY recharge_records (id, student_id, code, created_at, updated_at, recharge_code_id) FROM stdin;
1	3	nUq5/Z1Ggq966A99uMDvb6WcRWEVU6Ec	2014-06-25 12:42:39.244408	2014-06-25 12:42:39.244408	1
\.


--
-- Name: recharge_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('recharge_records_id_seq', 2, false);


--
-- Data for Name: register_codes; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY register_codes (id, value, state, created_at, updated_at, user_id, school_id, batch_id) FROM stdin;
7	413778-244	expired	2015-04-11 08:34:04.256107	2015-04-12 02:05:15.382408	59	\N	\N
6	679113-238	expired	2015-04-11 08:33:58.245667	2015-04-12 03:27:44.427626	60	\N	\N
1	386974-459	expired	2015-04-11 08:20:59.384963	2015-04-12 12:04:24.046463	61	\N	\N
2	027598-465	expired	2015-04-11 08:21:05.370474	2015-04-12 12:59:24.232355	62	\N	\N
5	941432-233	expired	2015-04-11 08:33:53.047988	2015-04-12 13:37:38.86906	63	\N	\N
3	034113-476	expired	2015-04-11 08:21:16.200848	2015-04-13 02:23:54.256388	65	\N	\N
4	029987-220	expired	2015-04-11 08:33:40.874663	2015-04-18 07:17:38.76837	66	\N	\N
8	066858-929	expired	2015-04-12 01:42:09.072481	2015-04-18 07:20:30.796324	67	\N	\N
9	054207-417	expired	2015-04-14 03:50:17.308902	2015-04-19 23:08:39.199931	68	\N	\N
10	958354-933	expired	2015-04-14 03:58:53.929389	2015-04-19 23:21:41.948437	69	\N	\N
11	452149-211	expired	2015-04-14 04:03:31.206575	2015-04-19 23:25:07.03759	70	\N	\N
12	873279-455	expired	2015-04-14 04:07:35.107529	2015-04-19 23:44:59.579339	71	\N	\N
13	945696-417	expired	2015-04-19 23:50:17.957564	2015-04-19 23:50:43.509915	72	\N	\N
14	720576-544	expired	2015-04-19 23:52:24.337342	2015-04-19 23:52:44.06811	73	\N	\N
15	143648-925	expired	2015-05-09 11:28:45.83266	2015-05-09 11:30:06.671047	74	\N	\N
16	579131-043	expired	2015-05-18 11:20:43.097366	2015-05-18 11:21:11.213129	75	\N	\N
17	883250-255	expired	2015-10-10 13:31:28.257681	2015-10-10 13:31:39.97388	76	\N	\N
\.


--
-- Name: register_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('register_codes_id_seq', 17, true);


--
-- Data for Name: replies; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY replies (id, content, topic_id, created_at, updated_at, token, author_id, customized_course_id, status, type, customized_tutorial_id) FROM stdin;
1	测试一下回复	1	2014-06-25 14:54:36.794327	2014-06-25 14:54:36.794327	aDtYDFdZEU3xUKIzeHj8LQ	2	\N	false	\N	\N
3	aqaq	10	2014-11-20 23:17:10.083375	2014-11-20 23:17:10.083375	FYPYXObE6KJgBbxzPMUR0w	2	\N	false	\N	\N
4	aaa	10	2014-11-20 23:18:44.119282	2014-11-20 23:18:44.119282	QrOEfoEvcDpkrUHUEJJFNg	2	\N	false	\N	\N
50	<p>原因是这样的。。。。。。。。。。。。。。。</p><p>。。。。。。。。。。。。</p>	36	2015-05-28 23:35:44.784911	2015-05-28 23:35:44.784911	1432856117-DgiWYaow0l4AW_nDxAUQcQ	2	\N	false	\N	\N
51	asdfasdfasdfasdfadafasdf	42	2015-09-18 05:45:02.376958	2015-09-18 05:45:02.376958	1442555094-flnTnhuLTDZXq7G_xpQ89Q	75	\N	false	\N	\N
52	测试一下么	45	2015-09-29 21:51:23.605003	2015-09-30 22:48:01.668955	1443563474-H7rXn4HKuErtxe3YYd103A	2	2	false	\N	\N
53	测试是否能有customized_course_id	53	2015-10-01 00:03:31.269354	2015-10-01 00:03:31.269354	1443657789-MF5qDQJ3SPf54c5rN5ZdDw	2	2	false	\N	\N
54	卡那可能有没有啊	52	2015-10-01 00:04:17.683947	2015-10-01 00:04:17.683947	1443657852-lnqyrTeScpl7burBCsEAEg	2	2	false	\N	\N
56	AD发水电费	62	2015-10-10 13:48:33.810044	2015-10-10 13:48:33.810044	1444484888-n8G8NTVIiQ3SnXK4Xvvwvw	76	3	open	\N	\N
55	爱仕达发生的罚	62	2015-10-10 13:48:08.486408	2015-10-10 14:19:06.158713	1444484767-0KejWLzhS_94rpriz9cHpQ	76	3	closed	\N	\N
57	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/7ec42e452a44030847fef64967b5a2d2.png" style="width: 1128px;"></p>	64	2015-10-11 09:06:51.66978	2015-10-11 09:06:51.66978	1444552234-VVwmnatHLS30m_McjPVXVg	57	2	open	TutorialIssueReply	13
58	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/7ec42e452a44030847fef64967b5a2d2.png" style="width: 1128px;"></p>	64	2015-10-11 09:08:42.46717	2015-10-11 09:08:42.46717	1444552234-VVwmnatHLS30m_McjPVXVg	57	2	open	TutorialIssueReply	13
59		64	2015-10-11 09:09:42.887548	2015-10-11 09:09:42.887548	1444554522-RhiSEZzy1ti62MNLfLHLbw	57	2	open	TutorialIssueReply	13
60		54	2015-10-11 12:18:22.982507	2015-10-11 12:18:22.982507	1444565871-bRbrWqRl9BkdCFSOWQAqnQ	57	2	open	\N	\N
61		54	2015-10-11 12:18:51.307032	2015-10-11 12:18:51.307032	1444565903-X5I1KWFgfEWYkWj4pVW9SA	57	2	open	\N	\N
62		54	2015-10-11 12:19:34.410809	2015-10-11 12:19:34.410809	1444565968-79r3XAGdJYEjQ3FHwWpTGg	57	2	open	\N	\N
63	<p>asdfadfasdfasdfasdfasdf<img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/4a937a6cf774f2be46de134a2a9861f3.png" style="width: 50%;"></p>	54	2015-10-11 12:36:43.679473	2015-10-11 12:36:43.679473	1444566036-QZGXWgm6JxCJ4CsGjnqNmQ	57	2	open	\N	\N
64	ertwertasdfadf!@#	64	2015-10-11 12:37:20.524559	2015-10-11 12:50:51.217027	1444566822-PUTCXnD7HlhEPe4VoaaZog	57	2	open	TutorialIssueReply	13
65	asdfasdf	64	2015-10-11 12:51:51.362513	2015-10-11 12:51:51.362513	1444567851-bJKDKPQypML993v_nTaHtA	57	2	open	TutorialIssueReply	13
66	ljlkj;lj;lkj;k	64	2015-10-11 12:58:16.177851	2015-10-11 12:58:16.177851	1444567911-MZWsChqU-jOh81yMevB5AQ	57	2	open	TutorialIssueReply	13
69	<p><br><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/2cb084d5b42a85f51d3c3d2ac885cf9e.png" style="width: 430px;"></p>	64	2015-10-11 13:42:23.271364	2015-10-11 13:42:23.271364	1444568311-ClHMTEbKd-ZyGgSEDA1Wpw	57	2	open	TutorialIssueReply	13
71	asdfasdfasdfadsfafasdfasdf	65	2015-10-18 01:05:17.92887	2015-10-18 01:22:32.909243	1445130122-gIMG37y361f9_Jwqts2C4w	76	3	closed	TutorialIssueReply	15
72	asdfasdf	71	2015-10-18 01:51:05.230348	2015-10-18 01:58:11.366432	1445133042-gnpvQKcnhiHsDlNoq5hoeg	76	3	closed	CourseIssueReply	\N
73	wrqwerqwreadf	72	2015-10-20 23:28:58.403288	2015-10-20 23:29:49.013847	1445383728-2VYZ_e3zcl3ZY5rB-2jDDg	75	3	open	TutorialIssueReply	15
74	爱仕达发生的罚	73	2015-10-20 23:34:46.157917	2015-10-20 23:34:46.157917	1445384077-1110TvMZBFSc1yI_Gcpi-A	75	3	open	CourseIssueReply	\N
\.


--
-- Name: replies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('replies_id_seq', 74, true);


--
-- Data for Name: review_records; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY review_records (id, lesson_id, manager_id, complete_state, start_state, reason, created_at, updated_at) FROM stdin;
1	86	\N	\N	editing	没有视频	2015-04-12 02:30:39.518104	2015-04-12 02:38:25.08208
2	87	\N	\N	editing	无声音	2015-04-12 02:34:04.15686	2015-04-12 02:39:30.518175
3	88	\N	\N	editing	没有声音	2015-04-12 02:40:38.583555	2015-04-12 02:44:58.189242
4	89	\N	\N	editing	\N	2015-04-12 02:45:20.562674	2015-04-12 02:45:20.562674
5	95	\N	\N	editing		2015-04-18 23:42:45.745883	2015-04-18 23:43:06.158513
6	95	\N	\N	editing	\N	2015-04-18 23:44:25.982139	2015-04-18 23:44:25.982139
7	97	\N	\N	editing	视频没有声音，模板要用绿色的。	2015-04-22 23:42:05.642435	2015-04-22 23:50:25.143612
8	97	\N	\N	published	\N	2015-04-22 23:50:54.737994	2015-04-22 23:50:54.737994
9	97	\N	\N	rejected	\N	2015-04-22 23:59:48.801474	2015-04-22 23:59:48.801474
10	157	\N	\N	editing	要用通用模板才可以	2015-05-18 11:56:31.413704	2015-05-18 11:57:00.664767
12	162	\N	\N	editing	\N	2015-06-16 21:57:22.022104	2015-06-16 21:57:22.022104
\.


--
-- Name: review_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('review_records_id_seq', 12, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY schema_migrations (version) FROM stdin;
20140222130920
20140223032528
20140223033520
20140223051701
20140223051845
20140223071345
20140223074118
20140226124617
20140305225304
20140306130047
20140306130147
20140306130315
20140306130815
20140306131441
20140306221317
20140311123908
20140312094127
20140312095333
20140320015920
20140401052008
20140403224243
20140403224453
20140403230901
20140404014034
20140409130656
20140409132122
20140412103208
20140414213120
20140414213324
20140414213442
20140414224705
20140419023310
20140419123532
20140420015644
20140422214000
20140422214346
20140422225021
20140422230017
20140424141054
20140430024312
20140504140524
20140504222733
20140505214250
20140512221458
20140521231449
20140522215422
20140522215806
20140522222959
20140523102748
20140523112842
20140525122507
20140525223014
20140526132712
20140526135410
20140526215705
20140526221214
20140527142914
20140603123117
20140606024110
20140715135059
20140720065618
20140720065913
20140720090732
20140720091344
20140720092408
20140720092418
20140720094916
20140720095053
20140722144056
20140722144226
20140723150655
20140728075810
20140730150504
20140731141225
20140815023344
20150303054404
20150304034705
20150304215140
20150305071306
20150310054956
20150314094417
20150317222952
20150319111638
20150321223536
20150323232824
20150325232120
20150326224620
20150326225027
20150403230006
20150406091838
20150418231515
20150419014540
20150419093311
20150419223539
20150422031154
20150426050743
20150427091825
20150428230204
20150503020448
20150505051907
20150505081235
20150511222259
20150518220029
20150526012719
20150530212333
20150531072243
20150622223913
20150622224721
20150622225410
20150624215508
20150628091557
20150628140230
20150628141749
20150709104500
20150721223549
20150812225417
20150815074013
20150817214018
20150823085734
20150824150905
20150830153509
20150904144328
20150907223348
20150915224831
20150916223349
20150916223428
20150918080250
20150918225721
20150920005600
20150920230949
20150921233645
20150922065112
20150917065037
20150922224445
20150930065701
20150930224154
20151001103156
20151001111946
20151002005725
20151004220553
20151005063822
20151006080542
20151007013711
20151002033027
20151002033106
20151002075749
20151002075818
20151002075839
20151002114452
20151003215255
20151003215337
20151003215404
20151003234734
20151003234743
20151004111320
20151006152104
20151008063643
20151008100014
20151008215450
20151010011502
20151010031014
20151010040025
20151010040206
20151011011457
20151011090454
20151012230526
20151019221754
20151021022259
20151021220724
20151021230805
20151022091330
20151022095437
20151022120851
20151022131128
20151022221124
20151023081725
20151024120518
\.


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY schools (id, name, city_id, created_at, updated_at) FROM stdin;
1	阳泉市一中	1	2014-06-25 12:20:30.820735	2014-06-25 12:20:30.820735
2	阳泉市十一中	1	2014-08-29 10:39:12.264596	2014-08-29 10:39:12.264596
3	阳泉市外国语学校	1	2014-08-30 03:21:46.873035	2014-08-30 03:30:13.670907
4	阳泉市十四中	1	2014-08-30 03:29:32.831949	2014-08-30 03:30:27.975258
5	阳泉十四中	1	2014-10-20 01:50:01.444096	2014-10-20 01:50:01.444096
7	十七中学	1	2014-11-06 07:25:07.65536	2014-11-06 07:25:07.65536
8	阳泉市郊区荫营中学	1	2015-04-11 08:29:09.757563	2015-04-11 11:13:44.132092
9	阳泉郊区三郊中学	1	2015-04-12 00:52:07.325782	2015-04-12 00:52:07.325782
10	阳泉郊区三泉中学	1	2015-04-12 00:53:42.358512	2015-04-12 00:53:42.358512
11	阳泉荫营第二中学	1	2015-04-12 00:55:06.801262	2015-04-12 00:55:06.801262
12	阳泉平定县东关初级中学校	1	2015-04-12 01:35:56.318005	2015-04-12 01:35:56.318005
13	阳泉师范高等专科学校	1	2015-04-12 01:36:52.320057	2015-04-12 01:36:52.320057
14	阳泉十五中学校	1	2015-04-12 01:38:06.471048	2015-04-12 01:38:06.471048
\.


--
-- Name: schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('schools_id_seq', 15, false);


--
-- Data for Name: searches; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY searches (id, created_at, updated_at) FROM stdin;
\.


--
-- Name: searches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('searches_id_seq', 1, false);


--
-- Data for Name: solutions; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY solutions (id, title, content, solutionable_id, student_id, token, corrections_count, created_at, updated_at, comments_count, solutionable_type, customized_course_id, first_handle_created_at, last_handle_created_at, first_handle_author_id, last_handle_author_id, type, examination_id, customized_tutorial_id) FROM stdin;
1	我看作业应该如何写呢		\N	75	1442537450-EsO1t_83XJinMkSBrQGb1g	\N	2015-09-18 00:51:07.742448	2015-09-18 00:51:07.742448	0	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	作业处理	安师大发安师大发	6	75	1443362646-Qrj-PAJVegQrzBrHgDJWLw	\N	2015-09-27 14:04:17.754924	2015-09-30 22:27:54.439887	0	Homework	2	\N	\N	\N	\N	\N	\N	\N
6	我看不错	确实不错	8	75	1443133698-1e1hOhpmhl4wwirg9bZJxA	1	2015-09-24 22:28:42.743596	2015-10-03 08:16:26.645495	0	Homework	2	2015-09-27 04:03:45.093425	2015-09-27 04:03:45.093425	2	2	\N	\N	\N
8	测试是否customized_course_id	测试是否有有customized_course_id	9	75	1443658531-eB9HoU4Mm9XS-8y27reiPA	1	2015-10-01 00:18:22.483412	2015-10-03 08:16:26.655664	0	Homework	2	2015-10-01 10:38:34.214857	2015-10-01 10:38:34.214857	2	2	\N	\N	\N
10	测试一下是否整的好的	测试是否真的好用呢	9	75	1443845734-kWWL8jwUGFAQwgmRlVJpKg	1	2015-09-23 04:20:53.31517	2015-10-03 08:16:26.665528	0	Homework	2	2015-10-03 04:22:26.285683	2015-10-03 04:22:26.285683	2	2	\N	\N	\N
9	ceshi  customized_course_id	ceshi	14	75	1443659141-0zNxdxPSm-YNqk05Ho4wEg	\N	2015-10-01 00:25:56.295706	2015-10-06 08:48:00.459308	0	Exercise	2	\N	\N	\N	\N	\N	\N	\N
5	看看还是行不行啊 修改下看看	看看还是行不行啊看看还是行不行啊SD发放	5	75	1442538404-N62x6Fc6tDairVbJoxpqoQ	9	2015-09-18 01:06:55.256093	2015-10-07 14:03:42.150489	2	\N	\N	2015-09-18 05:42:53.760921	2015-09-18 07:32:44.634723	2	2	\N	\N	\N
11	继续做作业	继续做作业	9	75	1443863897-9iQR8qpQrBuaYjBGPJMHaw	3	2015-10-03 09:18:32.291979	2015-10-07 14:03:42.252645	1	Homework	2	2015-10-07 13:26:56.796116	2015-10-07 13:30:43.150865	2	2	\N	\N	\N
13	asdfas	asdfasdf	18	75	1445292949-GBdnE3lg9-FgeP6yfpVASg	1	2015-10-19 22:16:09.00251	2015-10-19 22:17:24.838732	0	Homework	3	2015-10-19 22:17:24.805733	2015-10-19 22:17:24.805733	76	76	\N	\N	\N
14	asdfasdf	asdfasdfasdf	19	75	1445387976-YK9Q8P75UCEvVsPL_v3mQg	\N	2015-10-21 00:39:48.038826	2015-10-21 00:39:48.038826	0	Examination	3	\N	\N	\N	\N	\N	\N	\N
16	ceshi111111	cash2222222	\N	75	1445515583-cYq3k_2gqLkL3QxoDj7bQw	4	2015-10-22 12:06:35.081598	2015-10-24 05:33:13.277675	0	\N	3	2015-10-22 22:50:57.847266	2015-10-22 22:53:07.140889	76	76	HomeworkSolution	21	\N
18	123413	12341241324	\N	75	1445520462-aH4nUEETb2THZO1VtOjJdQ	\N	2015-10-22 13:28:10.824794	2015-10-22 13:28:10.824794	0	\N	3	\N	\N	\N	\N	ExerciseSolution	20	15
19	123413	12341241324	\N	75	1445520462-aH4nUEETb2THZO1VtOjJdQ	\N	2015-10-22 13:36:11.590357	2015-10-22 13:36:11.590357	0	\N	3	\N	\N	\N	\N	ExerciseSolution	20	15
21	aa	ss	\N	75	1445521180-Q5nf0FNPu8Yejg6J6AJzbg	\N	2015-10-22 13:39:50.094934	2015-10-22 13:39:50.094934	0	\N	3	\N	\N	\N	\N	ExerciseSolution	19	15
22	sdasdf	asdfasdfasf	\N	75	1445658314-mm6ggnRQGus15Dn-iUBKlg	1	2015-10-24 04:10:30.594025	2015-10-25 00:10:16.859796	0	\N	3	2015-10-25 00:10:16.840178	2015-10-25 00:10:16.840178	76	76	ExerciseSolution	19	15
17	12341234	12341234141	\N	75	1445518373-Xbm-6Ymt99y0w6NJEJHZ5w	3	2015-10-22 12:53:09.306451	2015-10-25 01:45:09.428956	0	\N	3	2015-10-23 08:22:50.830576	2015-10-25 01:45:09.342473	76	76	HomeworkSolution	22	\N
20	123413	12341241324	\N	75	1445520462-aH4nUEETb2THZO1VtOjJdQ	6	2015-10-22 13:36:30.259597	2015-10-23 08:19:23.868279	0	\N	3	2015-10-23 07:53:56.246321	2015-10-23 08:19:23.733765	76	76	ExerciseSolution	20	15
\.


--
-- Name: solutions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('solutions_id_seq', 22, true);


--
-- Data for Name: teaching_programs; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY teaching_programs (id, name, category, grade, subject, content, created_at, updated_at) FROM stdin;
1	必修1	高中	高一	物理	{"chapters": ["运动的描述", "匀变速直线运动", "相互作用", "牛顿运动定律"]}	2015-04-09 23:06:37.546435	2015-04-09 23:06:37.546435
2	必修2	高中	高一	物理	{"chapters": ["机械能及其守恒定律", "曲线运动", "万有引力与航天"]}	2015-04-09 23:06:37.556533	2015-04-09 23:06:37.556533
3	选修3-1	高中	高二	物理	{"chapters": ["静电场", "恒定电流", "磁场"]}	2015-04-09 23:06:37.565726	2015-04-09 23:06:37.565726
4	选修3-2	高中	高二	物理	{"chapters": ["电磁感应", "交变电流", "传感器"]}	2015-04-09 23:06:37.574148	2015-04-09 23:06:37.574148
5	选修3-3	高中	高二	物理	{"chapters": ["分子动理论", "气体", "物态和物态变化", "热力学定律"]}	2015-04-09 23:06:37.582415	2015-04-09 23:06:37.582415
6	选修3-4	高中	高二	物理	{"chapters": ["机械振动", "机械波", "光", "电磁波", "相对论简介"]}	2015-04-09 23:06:37.591499	2015-04-09 23:06:37.591499
7	选修3-5	高中	高二	物理	{"chapters": ["动量守恒定律", "波粒二象性", "原子结构", "原子核"]}	2015-04-09 23:06:37.599894	2015-04-09 23:06:37.599894
8	必修1	高中	高一	化学	{"chapters": ["从实验学化学", "化学物质及其变化", "金属及其化合物", "非金属及其化合物"]}	2015-04-09 23:06:37.608274	2015-04-09 23:06:37.608274
9	必修2	高中	高一	化学	{"chapters": ["物质结构 元素周期律", "化学反应与能量", "有机化合物", "化学与可持续发展"]}	2015-04-09 23:06:37.61669	2015-04-09 23:06:37.61669
10	选修1	高中	高二	化学	{"chapters": ["关注营养平衡", "促进身心健康", "探索生活材料", "保护生存环境"]}	2015-04-09 23:06:37.625784	2015-04-09 23:06:37.625784
11	选修2	高中	高二	化学	{"chapters": ["走进化学工业", "化学与资源开发利用", "化学与材料的发展", "化学与技术的发展"]}	2015-04-09 23:06:37.634513	2015-04-09 23:06:37.634513
12	选修3	高中	高二	化学	{"chapters": ["原子结构与性质", "分子结构与性质", "晶体结构与性质"]}	2015-04-09 23:06:37.644262	2015-04-09 23:06:37.644262
13	选修4	高中	高二	化学	{"chapters": ["化学反应与能量", "化学反应速率和化学平衡", "水溶液中的离子平衡", "电化学基础"]}	2015-04-09 23:06:37.652871	2015-04-09 23:06:37.652871
14	选修5	高中	高二	化学	{"chapters": ["认识有机化合物", "烃和卤代烃", "烃的含氧衍生物", "生命中的基础有机化学物质", "进入合成有机高分子化合物的时代"]}	2015-04-09 23:06:37.66175	2015-04-09 23:06:37.66175
15	选修6	高中	高二	化学	{"chapters": ["从实验走进化学", "物质的获取", "物质的检测", "研究型实验"]}	2015-04-09 23:06:37.670325	2015-04-09 23:06:37.670325
16	必修1	高中	高一	数学	{"chapters": ["集合", "基本初等函数", "函数的应用"]}	2015-04-09 23:06:37.679473	2015-04-09 23:06:37.679473
17	必修2	高中	高一	数学	{"chapters": ["空间几何体", "点、直线、平面之间的位置关系", "直线与方程", "圆与方程"]}	2015-04-09 23:06:37.687648	2015-04-09 23:06:37.687648
18	必修3	高中	高一	数学	{"chapters": ["算法初步", "统计", "概率"]}	2015-04-09 23:06:37.696215	2015-04-09 23:06:37.696215
19	必修4	高中	高一	数学	{"chapters": ["三角函数", "平面向量", "三角恒等变换"]}	2015-04-09 23:06:37.70437	2015-04-09 23:06:37.70437
20	必修5	高中	高二	数学	{"chapters": ["解三角式", "数列", "不等式"]}	2015-04-09 23:06:37.712842	2015-04-09 23:06:37.712842
21	选修1-1	高中	高二	数学	{"chapters": ["常用逻辑用语", "圆锥曲线与方程", "导数及其应用"]}	2015-04-09 23:06:37.721228	2015-04-09 23:06:37.721228
22	选修1-2	高中	高二	数学	{"chapters": ["统计案例", "推理与证明", "数系的扩充与复数的引入", "框图"]}	2015-04-09 23:06:37.730198	2015-04-09 23:06:37.730198
23	选修2-1	高中	高二	数学	{"chapters": ["常用逻辑用语", "圆锥曲线与方程", "空间向量与立体几何"]}	2015-04-09 23:06:37.739043	2015-04-09 23:06:37.739043
24	选修2-2	高中	高二	数学	{"chapters": ["导数及其应用", "推理与证明", "数系的扩充与复数的引入"]}	2015-04-09 23:06:37.747981	2015-04-09 23:06:37.747981
25	选修2-3	高中	高二	数学	{"chapters": ["计数原理", "随机变量及其分布", "统计案例"]}	2015-04-09 23:06:37.757138	2015-04-09 23:06:37.757138
26	必修1	高中	高一	生物	{"chapters": ["走近细胞", "组成细胞的分子", "细胞的基本结构", "细胞的物质输入和输出", "细胞的能量供应和利用", "细胞的生命历程"]}	2015-04-09 23:06:37.765149	2015-04-09 23:06:37.765149
27	必修2	高中	高一	生物	{"chapters": ["遗传因子的发现", "基因和染色体的关系", "基因的本质", "基因的表达", "基因突变及其他变异", "从杂交育种到基因工程", "现代生物进化理论"]}	2015-04-09 23:06:37.773896	2015-04-09 23:06:37.773896
28	必修3	高中	高二	生物	{"chapters": ["人体的内环境与稳态", "动物和人体生命活动的调节", "植物的激素调节", "种群和群落", "生态系统的稳定性", "生态环境的保护"]}	2015-04-09 23:06:37.782547	2015-04-09 23:06:37.782547
29	选修1	高中	高二	生物	{"chapters": ["传统发酵技术的应用", "微生物的培养与应用", "植物的组织培养技术", "酶的研究与应用", "DNA和蛋白质技术", "植物有效成分的提取"]}	2015-04-09 23:06:37.792439	2015-04-09 23:06:37.792439
30	选修3	高中	高二	生物	{"chapters": ["基因工程", "细胞工程", "胚胎工程", "生物技术的安全性和伦理性问题", "生态工程"]}	2015-04-09 23:06:37.801831	2015-04-09 23:06:37.801831
31	七年级上	初中	初一	数学	{"chapters": ["有理数", "整式的加减", "一元一次方程", "图形认识初步"]}	2015-04-12 02:15:20.11233	2015-04-12 02:15:20.11233
32	七年级下	初中	初二	数学	{"chapters": ["相交线与平行线", "实数", "平面直角坐标系", "二元一次方程组", "不等式与不等式组", "数据的收集、整理与描述"]}	2015-04-12 02:15:20.12194	2015-04-12 02:15:20.12194
33	八年级上	初中	初二	数学	{"chapters": ["三角形", "全等三角形", "轴对称", "整式的乘法与因式分解", "分式"]}	2015-04-12 02:15:20.129665	2015-04-12 02:15:20.129665
34	八年级下	初中	初二	数学	{"chapters": ["二次根式", "勾股定理", "平行四边形", "一次函数", "数据的分析"]}	2015-04-12 02:15:20.137316	2015-04-12 02:15:20.137316
35	九年级上	初中	初三	数学	{"chapters": ["一元二次方程", "二次函数", "旋转", "圆", "概率初步"]}	2015-04-12 02:15:20.14579	2015-04-12 02:15:20.14579
36	九年级下	初中	初三	数学	{"chapters": ["反比例函数", "相似", "锐角三角函数", "投影与视图"]}	2015-04-12 02:15:20.15343	2015-04-12 02:15:20.15343
37	八年级上	初中	初二	物理	{"chapters": ["机械运动", "声现象", "物变态化", "光现象", "透镜及其应用", "质量与密度"]}	2015-04-12 02:15:20.161037	2015-04-12 02:15:20.161037
38	八年级下	初中	初二	物理	{"chapters": ["力", "运动和力", "压强", "浮力", "功和机械能", "简单机械"]}	2015-04-12 02:15:20.169631	2015-04-12 02:15:20.169631
39	九年级	初中	初三	物理	{"chapters": ["热和能", "内能的利用", "电流和电路", "电压 电阻", "欧姆定律", "电功率", "生活用电", "电与磁", "信息的传递", "能源与可持续发展"]}	2015-04-12 02:15:20.17776	2015-04-12 02:15:20.17776
40	九年级上	初中	初三	化学	{"chapters": ["走进化学世界", "我们周围的空气", "物质构成的奥秘", "自然界的水", "化学方程式", "碳和碳的氧化物", "燃料及其利用"]}	2015-04-12 02:15:20.185769	2015-04-12 02:15:20.185769
41	九年级下	初中	初三	化学	{"chapters": ["金属和金属材料", "溶液", "酸和碱", "盐 化肥", "化学与生活"]}	2015-04-12 02:15:20.193121	2015-04-12 02:15:20.193121
42	七年级上	初中	初一	生物	{"chapters": ["认识生物", "生物圈是所有生物的家", "观察细胞的结构", "细胞的生活", "细胞怎样产生物体", "没有细胞结构的微小生物病毒", "生物圈中有哪些绿色植物", "被子植物的一生", "绿色植物与生物圈的水循环", "绿色植物是生物圈中有机物的制造者", "绿色植物与生物圈中的碳氧平衡", "爱护植被，绿化祖国"]}	2015-04-12 02:15:20.201704	2015-04-12 02:15:20.201704
43	七年级下	初中	初一	生物	{"chapters": ["人的由来", "人体的营养", "人体的呼吸", "人体内物质的运输", "人体内废物的排出", "人体生命活动的调节", "人类活动对生物圈的影响"]}	2015-04-12 02:15:20.211072	2015-04-12 02:15:20.211072
44	八年级上	初中	初二	生物	{"chapters": ["各种环境中动物", "动物的运动和行为", "动物在生物圈中的作用", "分布广泛的细菌和真菌", "细菌和真菌在生物圈中的作用", "根据生物的特征进行分类", "认识生物的多样性", "保护生物的多样性"]}	2015-04-12 02:15:20.219126	2015-04-12 02:15:20.219126
45	八年级下	初中	初二	生物	{"chapters": ["生物的生殖和发育", "生物的遗传和变异", "生物的进化", "传染病和免疫", "用药和急救", "了解自己 增进健康"]}	2015-04-12 02:15:20.227892	2015-04-12 02:15:20.227892
46	必修1	高中	高一	英语	{"chapters": ["Unit 1 Friendship", "Unit 2 English around world", "Unit 3 Travel journal", "Unit 4 Earthquake", "Unit 5 Nelson Mandela --- a modern hero"]}	2015-05-09 11:23:03.816005	2015-05-09 11:23:03.816005
47	必修2	高中	高一	英语	{"chapters": ["Unit 1 Cultural relics", "Unit 2 The Olympic Games", "Unit 3 Computers", "Unit 4 Wildlife Protection", "Unit 5 Music"]}	2015-05-09 11:23:03.827377	2015-05-09 11:23:03.827377
48	必修3	高中	高一	英语	{"chapters": ["Unit 1 Festivals around the world", "Unit 2 Healthy eating", "Unit 3 The Million Pound Bank Note", "Unit 4 Astronomy:the science of the stars", "Unit 5 Canada –\\"The True North\\""]}	2015-05-09 11:23:03.835868	2015-05-09 11:23:03.835868
49	必修4	高中	高一	英语	{"chapters": ["Unit 1 Women of achievement", "Unit 2 Working the land", "Unit 3 A taste of English humour", "Unit 4 Body language", "Unit 5 Theme parks"]}	2015-05-09 11:23:03.842644	2015-05-09 11:23:03.842644
50	必修5	高中	高二	英语	{"chapters": ["Unit 1 Great scientists", "Unit 2 The United Kingdom", "Unit 3 Life in the future", "Unit 4 Making the news", "Unit 5 First Aid"]}	2015-05-09 11:23:03.849624	2015-05-09 11:23:03.849624
51	选修6	高中	高二	英语	{"chapters": ["Unit 1 Art", "Unit 2 Poems", "Unit 3 A healthy life", "Unit 4 Global warming", "Unit 5 The power of nature"]}	2015-05-09 11:23:03.856709	2015-05-09 11:23:03.856709
52	选修7	高中	高二	英语	{"chapters": ["Unit 1 Living well", "Unit 2 Robots", "Unit 3 Under the sea", "Unit 4 Sharing", "Unit 5 Traveling abroad"]}	2015-05-09 11:23:03.864867	2015-05-09 11:23:03.864867
53	选修8	高中	高二	英语	{"chapters": ["Unit 1 A land of diversity", "Unit 2 Cloning", "Unit 3 Inventors and inventions", "Unit 4 Pygmalion", "Unit 5 Meeting your ancestors"]}	2015-05-09 11:23:03.872052	2015-05-09 11:23:03.872052
\.


--
-- Name: teaching_programs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('teaching_programs_id_seq', 53, true);


--
-- Data for Name: teaching_videos; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY teaching_videos (id, name, token, vip_class, teacher_id, question_id, answer_id, created_at, updated_at, video_type, state, convert_name) FROM stdin;
1	43dae08f36a19d39b340b34638937dc9.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:16:33.654976	2015-04-13 13:16:33.654976	mp4	not_convert	\N
2	c75fa2a2aead09fb8405bf7045f398c9.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:18:02.170163	2015-04-13 13:18:02.170163	mp4	not_convert	\N
3	a40d4615e4afd293638c9b5b91c5e315.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:18:47.269469	2015-04-13 13:18:47.269469	mp4	not_convert	\N
4	e73530e249e02981b0593bf03206e1e9.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:19:57.078	2015-04-13 13:19:57.078	mp4	not_convert	\N
5	d8a1c86391948f45010251c1211ee8f2.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:22:22.252814	2015-04-13 13:22:22.252814	mp4	not_convert	\N
6	9ba003019ef8a4b51b754a3acb0aa11c.mp4	2X15hPJn7554-Myhr_dSVA	\N	26	1	3	2015-04-13 13:23:02.632087	2015-04-13 13:23:02.632087	mp4	not_convert	\N
7	f0369a012c5697ab747854a0b0a4bc9e.mp4	VA8lxqchOT-t5ZZHkWwD3Q	\N	65	2	7	2015-04-14 11:52:31.019519	2015-04-14 11:52:31.019519	mp4	not_convert	\N
8	f7175658b3b67ed9ddb11e6443a91465.mp4	VA8lxqchOT-t5ZZHkWwD3Q	\N	65	2	7	2015-04-18 23:22:05.991137	2015-04-18 23:22:05.991137	mp4	not_convert	\N
9	8c7db2764c0d8bca81f62c65351ec034.mp4	VA8lxqchOT-t5ZZHkWwD3Q	\N	65	2	7	2015-04-19 00:21:20.721241	2015-04-19 00:21:20.721241	mp4	not_convert	\N
10	a502fa70108f130ae88c550491f0d1e2.mp4	3T0MCCqY23xHU2q3XwtWTw	\N	66	7	10	2015-04-20 01:58:54.225993	2015-04-20 01:58:54.225993	mp4	not_convert	\N
11	37507b9a6d4b4881f57c54e0e8e7cd2b.mp4	Ci9mj4nGH8wWy-Df2jnqXg	\N	\N	\N	\N	2015-04-22 01:28:27.530664	2015-04-22 01:28:27.530664	mp4	not_convert	\N
12	aa8a87c6d1ee40bdfd7cb0168f7f3be3.mp4	1430022354-Sv9MzDd2Woxb897KnN6GCQ	\N	\N	\N	\N	2015-04-26 04:26:24.93937	2015-04-26 04:26:24.93937	mp4	not_convert	\N
13	f12b0257d5acabefb09ab88a30174b61.mp4	1430618213-YDvuL0f_hUqR928MSW3WNg	\N	\N	\N	\N	2015-05-03 01:57:07.846821	2015-05-03 01:57:07.846821	mp4	not_convert	\N
14	601d01387227ad19e2d95b9e1c3dd2a6.mp4	1430618213-YDvuL0f_hUqR928MSW3WNg	\N	\N	\N	\N	2015-05-03 02:01:18.927637	2015-05-03 02:01:18.927637	mp4	not_convert	\N
15	6cab9d9de03691ce089270bc2db6b547.mp4	1430618213-YDvuL0f_hUqR928MSW3WNg	\N	\N	\N	\N	2015-05-03 02:02:21.997051	2015-05-03 02:02:21.997051	mp4	not_convert	\N
16	87de6a79498f08d7224c7b7c2b41395f.mp4	1430618213-YDvuL0f_hUqR928MSW3WNg	\N	\N	\N	\N	2015-05-03 02:06:20.997953	2015-05-03 02:06:25.327369	mp4	in_queue	\N
17	bec552af38e82bb22a223fe66e039956.mp4	1430618795-FcTcRRoNAdyuqCHYiLYDZQ	\N	\N	\N	\N	2015-05-03 02:12:01.440804	2015-05-03 02:12:06.002416	mp4	in_queue	\N
18	c707aec7d50b70e54de00fd357b8093d.mp4	1430622742-BzUFLCMYACY_dfh0kOVhjA	\N	\N	\N	\N	2015-05-03 03:12:35.339519	2015-05-03 03:12:39.317128	mp4	in_queue	\N
19	bbf03e684966edd5c8a7c365cac574a9.mp4	1430623595--pk8hazBupvbSo1XOHOnxA	\N	\N	\N	\N	2015-05-03 03:26:50.814332	2015-05-03 03:28:10.355391	mp4	convert_success	b0fc08a813e70d040d26801bb59e27d3.mp4
20	b55671f33913de0aed1818d237d5bb3f.mp4	1430748047-9AG2UEdlQdIWGG7ZhdcE1w	\N	2	16	15	2015-05-04 14:00:57.114897	2015-05-11 23:23:12.627357	mp4	convert_success	d08af86f23e28cb279735b48525e12f6.mp4
\.


--
-- Name: teaching_videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('teaching_videos_id_seq', 20, true);


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY topics (id, title, content, replies_count, created_at, updated_at, token, course_id, author_id, curriculum_id, topicable_id, delete_learning_plan_id, teacher_id, topicable_type, customized_course_id, type, customized_tutorial_id) FROM stdin;
1	测试一下提问	<img src="http://qatime.oss-cn-beijing.aliyuncs.com/images/41bc3e59eb5043d63233ec971c8a1c81.JPG" style="width: 402.5px;"><br><div><br></div><div>提问的图片真帅</div>	1	2014-06-25 13:20:14.961545	2015-04-09 23:06:40.631349	AfRwSUqJWSXEk2vk0tQmZQ	1	4	1	\N	\N	\N	Lesson	\N	\N	\N
2	事实上	安师大发啥地方	0	2014-06-27 08:31:51.640529	2015-04-09 23:06:40.637527	2VZx9JhuzA_cbgRS4lyE3w	6	4	1	\N	\N	\N	Lesson	\N	\N	\N
3	师大发啥地方12341234	按时到发送的	0	2014-06-27 08:32:47.303017	2015-04-09 23:06:40.642893	Pm2Flar8TERQ2KB5tBYUPA	6	4	1	\N	\N	\N	Lesson	\N	\N	\N
4	11	11	0	2014-08-14 15:01:28.40435	2015-04-09 23:06:40.648318	ebZRhv4PRyi57l751DTU6Q	1	5	1	\N	\N	\N	Lesson	\N	\N	\N
5	zz	cccccc	0	2014-08-28 09:41:50.353377	2015-04-09 23:06:40.653661	k4mFcOjweAYLzueEu_WkJg	13	6	1	\N	\N	\N	Lesson	\N	\N	\N
6	xx	xx	0	2014-08-28 09:56:57.491334	2015-04-09 23:06:40.659133	37hhqS5wAbisOTu0aaSb8w	13	6	1	\N	\N	\N	Lesson	\N	\N	\N
7	nn	ccccc	0	2014-08-28 10:02:26.971596	2015-04-09 23:06:40.664419	hVWahbzrzQU5c0DAwuO9PA	13	6	1	\N	\N	\N	Lesson	\N	\N	\N
8	bb	最好有一个封面	0	2014-08-28 10:04:45.411779	2015-04-09 23:06:40.669641	LqEK5kAO2WcpyeIfseglIw	13	6	1	\N	\N	\N	Lesson	\N	\N	\N
9	bb	最好	0	2014-08-28 10:05:30.10554	2015-04-09 23:06:40.674725	LqEK5kAO2WcpyeIfseglIw	13	6	1	\N	\N	\N	Lesson	\N	\N	\N
10	qaqa	time	2	2014-11-20 23:15:44.710186	2015-04-09 23:06:40.679789	dCjq_sfUqW06f56k4wX3-g	23	6	162	\N	\N	\N	Lesson	\N	\N	\N
11	mnmn	<span class="Apple-style-span" style="font-weight: bold;">aaa</span>	0	2014-11-20 23:21:50.994467	2015-04-09 23:06:40.684857	9dm0jRvy2xbyaEgbQoigrQ	23	6	162	\N	\N	\N	Lesson	\N	\N	\N
12	,,,,,,,,	fghhhhhhhhh	0	2014-12-03 10:18:43.502644	2015-04-09 23:06:40.690214	iCwqe4s-ZqphZUH6Gai_zA	23	6	162	\N	\N	\N	Lesson	\N	\N	\N
13	知识要点有些啥？	必修一内容知识要点的归纳总结。	0	2015-01-04 11:34:57.208557	2015-04-09 23:06:40.695415	b4qd_8MXsggPXzNAEYJSDQ	13	45	1	\N	\N	\N	Lesson	\N	\N	\N
14	<script type="text/javascript"> document.write("Hello World!") </script>	<em>&lt;script</em> type="text/javascript"&gt; document.write("Hello World!") &lt;/script&gt;	0	2015-01-04 16:44:04.176452	2015-04-09 23:06:40.700468	5ySMvlGMWzC6MQ7-bABmCA	13	48	1	\N	\N	\N	Lesson	\N	\N	\N
15	<script type="text/javascript"> document.write("Hello World!") </script>	fdsafdsa	0	2015-01-04 16:45:43.361985	2015-04-09 23:06:40.70553	94uGVk3RLswe2Ez_e7L8mA	13	48	1	\N	\N	\N	Lesson	\N	\N	\N
36	这个课程中讲解的第一个例题有一些疑问	<p>讲解中，速度的我认为应该使用公式f=ma 为什么不使用呢？</p><p>谢谢老师</p>	1	2015-05-28 23:22:54.448911	2015-05-28 23:22:54.448911	1432855226-SCdEYdRBUNKLWQxe2bwH6A	80	75	323	97	\N	2	Lesson	\N	\N	\N
37	哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈	哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈	0	2015-05-29 14:58:36.769078	2015-05-29 14:58:36.769078	1432911506-LELUKCg8cZIUH91Klf1rmg	80	2	323	159	\N	2	Lesson	\N	\N	\N
34	测试测试测试测试测试测试	哈哈哈哈哈哈哈哈哈哈哈哈哈哈	0	2015-05-28 12:40:03.834803	2015-05-28 12:40:03.834803	1432816782-RdfhOvr-gcaieK18x9yQPQ	69	75	3	81	\N	7	Lesson	\N	\N	\N
38	测试是否好用呢啊啊啊啊嗄	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/067d00ef8f304f5d7d5b2b6719f09f7e.png" style="width: 683px;"></p>	0	2015-08-27 06:17:40.871788	2015-08-27 06:17:40.871788	1440656232-PYM9YH2Y5G_2jSFDwmubVA	\N	2	\N	97	\N	2	Lesson	\N	\N	\N
42	测试是否可以看到	是否可以看到有没有这个测试结果	1	2015-09-09 05:18:19.813584	2015-09-09 05:18:19.813584	1441775878-kGoH0zRztxjJaPP0iJd_Lg	\N	75	\N	5	\N	2	Homework	\N	\N	\N
45	weisha mei kecheng	ceshi nick name	1	2015-09-29 21:49:48.238487	2015-09-30 22:48:01.65273	1443563373-sftqdDxKAJJO0JAy7vZREw	\N	2	\N	13	\N	2	CustomizedTutorial	2	\N	\N
48	ceshi shifou you	则很难过的有耳麦	0	2015-09-30 23:00:43.727704	2015-09-30 23:00:43.727704	1443654029-RPzJo3PbcCOXJ1WQbZVDPg	\N	2	\N	2	\N	2	CustomizedCourse	\N	\N	\N
49	customized course id		0	2015-09-30 23:02:17.222729	2015-09-30 23:02:17.222729	1443654109-KJDagcVAWXf9L2r1Sb-2-Q	\N	2	\N	2	\N	2	CustomizedCourse	\N	\N	\N
39	sssss dddd aaaa11111111111111111111111111111111	<p><br><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/5b89dd0aa598e8f80ea36feb87798fef.jpg" style="width: 768px;"><img style="width: 1024px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/e995159f2e9aa7abd5fba769081ff198.jpg"><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/210e63c78d5b678bcc1b9f1009fc073c.jpg" style="width: 768px;"><img src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/56149671c310266b7bc2ad2d389cbb73.jpg" style="width: 1024px;"></p>	0	2015-08-27 11:37:20.616161	2015-09-30 22:48:01.541017	1440675344-vKR-YewaruJ98k3t_YFXWA	\N	75	\N	2	\N	2	CustomizedCourse	2	\N	\N
40	haoahaohoahoaohaohoaohaohohah	<p><br><img style="width: 300px;" src="http://qatime-test.oss-cn-beijing.aliyuncs.com/images/a4ee401083a7dd131f91246dba205a74.jpg"></p>	0	2015-08-27 11:38:40.689115	2015-09-30 22:48:01.586665	1440675486-QhWSTd5Rey70uNF7RYZUxQ	\N	75	\N	2	\N	2	CustomizedCourse	2	\N	\N
44	测试一下是否重定向是正确的	测试一下是否重定向是正确的	0	2015-09-24 23:25:17.539283	2015-09-30 22:48:01.622413	1443137099-rkljoKY9_gD6R91DR9XRBQ	\N	2	\N	2	\N	2	CustomizedCourse	2	\N	\N
43	测试是多少啊	测试是多少啊测试是多少啊测试是多少啊测试是多少啊	0	2015-09-15 12:24:05.536383	2015-09-30 22:48:01.643637	1442319831-OMON7ypdRNcTh8e29DYYXQ	\N	2	\N	1	\N	2	CustomizedTutorial	2	\N	\N
46	测试是否设置customized_course_id	测试一下么	0	2015-09-30 22:56:36.376426	2015-09-30 22:56:36.376426	1443653762-yv3ZmSdAKAi2DmvGNpYGIg	\N	2	\N	13	\N	2	CustomizedTutorial	\N	\N	\N
47	测试一下是否有customized_course_id	测试一下是否有customized_course_id	0	2015-09-30 22:57:46.720933	2015-09-30 22:57:46.720933	1443653843--x31MOwhRU99uyS6T75OMA	\N	2	\N	2	\N	2	CustomizedCourse	\N	\N	\N
50	测试测试测试	测试测试测试	0	2015-09-30 23:04:06.684401	2015-09-30 23:04:06.684401	1443654236-milwSh4MJqcXv0vPwU14gA	\N	2	\N	13	\N	2	CustomizedTutorial	\N	\N	\N
51	测试一下啊	测试	0	2015-09-30 23:05:49.169114	2015-09-30 23:05:49.169114	1443654338-uaul7ylArZwB2r1yN9TIDg	\N	2	\N	13	\N	2	CustomizedTutorial	\N	\N	\N
53	测试	测试	1	2015-09-30 23:50:20.065126	2015-09-30 23:50:20.065126	1443656972-fkDr4zOLqX4lz5kzsn3PJg	\N	2	\N	2	\N	2	CustomizedCourse	2	\N	\N
52	测试有没有	测试有没有测试有没有	1	2015-09-30 23:48:54.561007	2015-09-30 23:48:54.561007	1443656923-L921_UZNFDIvjy3qvFxP6w	\N	2	\N	13	\N	2	CustomizedTutorial	2	\N	\N
57	~~~~~~	~~~~~~~	0	2015-10-07 08:02:00.143836	2015-10-07 08:02:00.143836	1444204909-MRghZtV5joNXfyKjZw2FUA	\N	75	\N	3	\N	\N	TutorialIssue	\N	\N	\N
58	kaka12341234124	1234123412	0	2015-10-07 08:11:35.886531	2015-10-07 08:11:35.886531	1444205485-fhUAeBFRfyepXsKe1qO2AA	\N	75	\N	4	\N	\N	TutorialIssue	\N	\N	\N
59	12341`````	```12`313`123`	0	2015-10-07 08:13:05.7478	2015-10-07 08:13:05.7478	1444205578-psLH1eLyG5K2RBnhv_C7tA	\N	75	\N	5	\N	\N	TutorialIssue	\N	\N	\N
60	hahahhahahahah	kankan nebuneng bianjiassddss	0	2015-10-07 09:12:30.681122	2015-10-07 09:17:10.318334	1444209127-F2Rn8bVOiFUSLvad4LIqZQ	\N	75	\N	6	\N	\N	TutorialIssue	\N	\N	\N
61	asdfasd	123412341234	0	2015-10-07 22:33:09.839786	2015-10-07 22:33:09.839786	1444257180-ulzSX1Yr2gdIYdu_B2O6sQ	\N	2	\N	7	\N	\N	TutorialIssue	\N	\N	\N
63	kankan zayangzime	adfasdfasdfasdf	0	2015-10-11 07:41:40.718977	2015-10-11 07:41:40.718977	1444549287-P_n67X6XdnlLBFdvkYPPYg	\N	57	\N	\N	\N	\N	\N	2	TutorialIssue	13
62	CC撒都是翻	安师大发都是翻	2	2015-10-10 13:46:06.538956	2015-10-10 13:46:06.538956	1444484750-WO4MIUtO4zh37sZAJt1UAw	\N	76	\N	15	\N	76	CustomizedTutorial	3	\N	\N
54	测试下能否在首页展示	看看吧	4	2015-10-03 22:54:50.236075	2015-10-03 22:54:50.236075	1443912871-rU1VN1UaGuNQbOUIxYe3bw	\N	75	\N	13	\N	2	CustomizedTutorial	2	\N	\N
64	kankan zayangzime	adfasdfasdfasdf	7	2015-10-11 07:54:08.809019	2015-10-11 07:54:08.809019	1444549287-P_n67X6XdnlLBFdvkYPPYg	\N	57	\N	\N	\N	\N	\N	2	TutorialIssue	13
70	dasdf	1341234124	0	2015-10-15 22:59:11.080584	2015-10-15 22:59:11.080584	1444949939-jcv4BzEr8KYx-B3f0zXYCg	\N	57	\N	\N	\N	\N	\N	3	CourseIssue	\N
65	asdfasd	asdfasdfasf	1	2015-10-14 23:24:35.849478	2015-10-14 23:24:35.849478	1444865066-kd6KDPVP80AbWBq7Fu_BTA	\N	57	\N	\N	\N	\N	\N	3	TutorialIssue	15
71	asdfasd	123412341244	1	2015-10-17 00:38:27.959266	2015-10-17 00:38:27.959266	1445042291-17XdWqaCIjuBlM9Xi8EafA	\N	57	\N	\N	\N	\N	\N	3	CourseIssue	\N
72	1234	12341234	1	2015-10-20 22:09:24.275154	2015-10-20 22:09:24.275154	1445378954-SJXtNEZS7yX_ObDozShSZA	\N	75	\N	\N	\N	\N	\N	3	TutorialIssue	15
73	测试下看看么	测试下么	1	2015-10-20 23:33:53.502718	2015-10-20 23:33:53.502718	1445384017-N-i1sKLnJtjACeTNisHIEQ	\N	75	\N	\N	\N	\N	\N	3	CourseIssue	\N
\.


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('topics_id_seq', 73, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, topics_count, replies_count, name, avatar, school_id, role, password_digest, remember_token, "desc", course_purchase_records_count, joined_groups_count, subject, category, mobile, pass, grade, nick_name) FROM stdin;
3	li_xuesheng@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-06-25 12:40:34.006373	2014-12-29 06:32:37.705435	0	2	学生	9dfe3ef10e3bfa67d9a42d69c20b1a01.JPG	\N	student	$2a$10$p9E6itObb7JE9R2d08OrJep5wdhO21z12P6hU1UMAFDK3KJzhrsKi	abe5331eddd52084ee17478abfaefc03b1cbee84	\N	1	1	\N	\N	\N	f	\N	\N
22	xxlld@126.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-30 03:31:47.833154	2015-04-14 10:51:08.853261	0	0	信相林	a1b43231dafb77ee32e0d142a5ae8e5c.jpg	4	teacher	$2a$10$sZQk7n4679Eoi7mtyXTtOelHsD574R89.wCkFpjEYoXh8XS7dG2GO	fa4ffd3ee675b75a2332a73511472134eb919762	阳泉市十四中优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
5	linken1110@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-14 14:59:23.790666	2014-08-14 14:59:24.647475	1	0	林延春	2679df590cd11d55c71dfc59e274770c.png	\N	student	$2a$10$wqNlxkDsFjKGsV7g4wKM/.3whn3drExm71bCmqGl7513eC/IergeS	7aa69fec2d27824b658bf39da57b47096ff217d7	\N	\N	0	\N	\N	\N	f	\N	\N
14	596530623@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:55:52.07281	2014-08-29 11:06:34.648592	0	0	赵海英	c56fc039e26e1617716ba3ace8e4dcf8.jpg	2	teacher	$2a$10$ywaNVa6qjCuwAiR4A/gF1.VLP6TNlGRd2jIaVKTD/fRZDRy30GOIq	3bc10533996fe4169f25e773530d5bbbdd00fd86	十一中高中部优秀语文老师	\N	0	\N	\N	\N	f	\N	\N
15	dzngxs@sohu.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:57:02.631434	2014-08-29 11:06:58.038274	0	0	郭旺兴	aeb3661208d9d9720b728ec30b27b762.jpg	2	teacher	$2a$10$sBvGk9NiuWK9Y1H297TVpevFU54ZQDbuIuUDevbHwuRtZgQXm1Os6	2136f8ed962654b7fee03f0f4f40b9bdc4205876	十一中初中部优秀语文老师	\N	0	\N	\N	\N	f	\N	\N
4	zhang_xuesheng@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-06-25 12:47:26.76808	2014-09-01 09:26:30.684118	3	0	学生2	3914b6bd7597901ef1ecabc6979a35dc.JPG	\N	student	$2a$10$J8RZjQOL09qp0mxzMprCme/AqmzBIIRbybIUnimYSanCVLkV1cVvu	3df67a98f90a5460f8c6a002c551a2f5a679e45e	\N	\N	0	\N	\N	\N	f	\N	\N
54	qatime@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-02-08 08:22:38.634337	2015-02-13 09:25:47.476882	0	0	qatest	0607570428fd4608cc3ec5894a65d7a7.jpg	\N	student	$2a$10$ktos1P0VFBRpUBzKVVdCsOHseN8IdvxO/HIYd5XGGgPgfpY/HvmJq	d445e1eed219d97e0ce9e42a02b5f87083922447	\N	\N	0	\N	\N	\N	f	\N	\N
37	workshop1314@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:37:59.244477	2015-04-09 23:06:40.192745	0	0	李会林	7f5b9669166777f30a6da0dd6dddd2f0.jpg	7	teacher	$2a$10$F5Y7YxBXB22MKYjBAtBGBuifVtKZInGjWEOJDd.jVl.jsYIoSaPmq	e25212bef0655551a612a3cd42482b9af85a471a	阳泉市17中高中部优秀化学老师	\N	0	化学	高中	\N	f	\N	\N
33	wzhqe@126.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:27:02.997606	2015-04-09 23:06:40.206405	0	0	王正庆	75c1dc593e0952c34fab9574cc779f59.jpg	7	teacher	$2a$10$M5.XpYQNwP.cTxDGDnkszeS5Yovh4Er.dHMSgjz8CTjaqli841diy	44c1cedc095126e4869bba6c94771d6a6a97385b	阳泉市17中学优秀生物老师	\N	0	生物	高中	\N	f	\N	\N
31	llhhxx00000@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:36:37.338681	2015-04-09 23:06:40.238011	0	0	刘海霞	b4b5550cf5b5de095316af5834dabdec.jpg	4	teacher	$2a$10$E2/w6rOfv6jkz6rek3W9BufuHyLuCyam2DKl43BJ11fyK5LJaLj26	d849d94d654580e684194ab5da878018c1a2d620	阳泉市十四中高中部优秀化学老师	\N	0	化学	高中	\N	f	\N	\N
16	Wangjianhui2008@sohu.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:58:09.468648	2015-04-09 23:06:40.264779	0	0	王建辉	c339d9bb2e93eed2105887a09645e91a.jpg	2	teacher	$2a$10$M.E2BOQHBPChtAPEvky9r.HOnpamMqEPhRUN5TLRh5fRynozQQEw.	c9a0edae57dfc533925ccb95d8750a3749202164	十一中优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
17	yjm7079330@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:59:20.787359	2015-04-09 23:06:40.277695	0	0	杨建明	97870510f5cf6b6b8a32bdb3442b22b7.jpg	2	teacher	$2a$10$ccm7we.8Ua8SVuHNkY8es.caQxw8MW6Ds1BzC2JDdIigQSTNheAlC	9bb6eb3d03769cf5f788d9d6896d68398ef553a0	十一中优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
19	muQiBin@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 11:01:36.487776	2015-04-09 23:06:40.29053	0	0	穆启斌	ffa4d3493d0d5f4b5d9a2ef9ea76c8d9.jpg	2	teacher	$2a$10$vW1HT0MHj8xUPmoSipz2G.f3yTCwCvcBH/c9XeV4TdYlYBUWYSzvG	907edbfcc62da6445be65499d8fd8075c2bb4cec	十一中优秀高中数学老师	\N	0	数学	高中	\N	f	\N	\N
18	guoer1131@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 11:00:26.540166	2015-04-09 23:06:40.303366	0	0	任国文	e5c606f110891935aa60954a3bb45fc1.jpg	2	teacher	$2a$10$zLodGjuyFAhthGa38Eprv.uasn0q8d.HsbGQUnGm036errx3Y4gBG	8624bbe87b09d78d1ebd503e002b9d648eb3b248	十一中初中优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
27	Liushuwu680329@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:24:39.976095	2015-04-09 23:06:40.360199	0	0	刘树武	bb7b7fd2a70e1da3be62662ce7c4d88a.jpg	4	teacher	$2a$10$iAMUn3Nwc9AgnbsoWR1TaulumRwS.L/R5WDT/4.ILiYB1EMttfVkO	546f7a3bd4833657afdd66c9732329a6576d9315	阳泉市十四中高中部优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
23	675426059@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 01:55:17.535126	2015-04-09 23:06:40.387159	0	0	康庆华	4faeadfac50247f2c53a934089025876.jpg	4	teacher	$2a$10$18rYZ7mUOYQmeE7k3fXrxOSdDSbWsmJa0PHGSRFJ6fhZIgF9RA1IG	be634afd16e9c4852459e20109db2ed5e246d97e	阳泉市十四中高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
30	Hanxue19811103@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:34:54.142599	2015-04-09 23:06:40.41342	0	0	李婷	e4e904c9750476ba6394ff90bb118ccd.jpg	4	teacher	$2a$10$Ctw08qbT1nB/0Cgg94KxR.JdtRxUdd9D4Wo0LB.QnXFp/9cmh1cG6	4930e76c4d29d6c7c7c65f3bec1a434b8b1f0351	阳泉市十四中高中部优秀生物老师	\N	0	生物	高中	\N	f	\N	\N
34	zlsxyq@126.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:31:09.313103	2015-04-09 23:06:40.428089	0	0	张乐	55ab16f80d065b177d85d746ed74f473.jpg	7	teacher	$2a$10$mlPQvQPENdd/CSKU50cyaOe1nvZ.fZCcQT.KZ0b8ZdO2m8KHGiPpS	80ca9a8991daafdcbd3bcd0c6f9e123640ec4798	阳泉市17中高中部优秀生物老师	\N	0	生物	高中	\N	f	\N	\N
52	760331799@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-18 07:41:52.817705	2015-01-18 07:41:53.115923	0	0	李	2e0bb5edf31365cb2cfbfbc5e00a9442.jpg	\N	student	$2a$10$Mxjx1VYEUoc6uVZQ5PgrxeqHaD2Vf79q/p8A1wZiANKp5LVEzA26W	2092568729b141df53bf1cd025536578075aa745	\N	\N	0	\N	\N	\N	f	\N	\N
1	zhangjiandongjesical@gmail.com		\N	\N	\N	0	\N	\N	\N	\N	2014-06-25 08:09:04.363666	2014-12-29 06:33:00.782967	0	0	张建东	cff7485df010a8be6bd896342e5fd0d9.JPG	\N	admin	$2a$10$FNPeIxtMpZYSe7xPnHKo3ukVN5Biy3dokPGj/L8bD9bMcz9t4XUFO	41d5ea2ba39a3ba23361ec8330f2f362cb2f86a8	\N	\N	0	\N	\N	\N	f	\N	\N
55	476076107@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-02-14 06:47:31.343035	2015-02-14 06:50:14.584579	0	0	李永美	21897567f85f0c66f6d12018ca28fcbc.jpg	\N	student	$2a$10$h0/6VpdA8Cdxq6cwBVcWduN1R6g4oTtXD36XGbgedxnfWZERdXcnO	da1599c8e8f26d31b87e8a1d6105fa7870c9af60	\N	\N	0	\N	\N	\N	f	\N	\N
51	862190118@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-10 01:33:49.321346	2015-03-26 00:21:37.71667	0	0	张燕军	a1bf9f3e6e4faab86a45ddb92021a2c8.jpg	\N	student	$2a$10$Et.Yp/kDbWk4j5PkP0bb8emf1n5xqiHGqKLXHnSiPAiBXThxwtkPm	bf214c329e8802e78c03f35fc524bd744224ad52	\N	\N	0	\N	\N	\N	f	\N	\N
45	wwx1005@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-04 11:32:01.872442	2015-01-04 11:35:39.951258	1	0	王卫星	1014e3c25020b109cc1cb27b5f538655.jpg	\N	student	$2a$10$ibTjCHPBrebtjU1/R98hn.FyjAZ5ws6VmKwjolUgFzMS56axoMJk2	57374dcd2d1a27648d064628d46fdde97a6cca64	\N	\N	0	\N	\N	\N	f	\N	\N
43	zzq0988@126.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-01 04:37:27.287938	2015-01-28 11:24:30.463114	0	0	郑忠青	487033d4aceb1fd446f596e135462c95.jpg	\N	student	$2a$10$s1wg6gQhaq7Dme8r0lMla.cwJeyYZhiIoj0q8uLJg60XblVh0L11y	1a453ade6b6a605955253dfefa867bdcb1b77dc8	\N	\N	0	\N	\N	\N	f	\N	\N
44	lllzzzqqqyj@126.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-01 04:39:50.407305	2015-01-11 03:48:32.973971	0	0	雷子清	1aad701b85c84c810cb8f9a82ae644a7.jpg	\N	student	$2a$10$n/4MmT0YaMr.D6H6xJFa9.hq5Ki85ChBYDt8d6VAGlGe1hYAJurKO	fae6e2ad2b4889e795956079855fe2b649edf84e	\N	\N	0	\N	\N	\N	f	\N	\N
9	YQZY5888@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:47:03.265444	2015-05-05 09:35:11.749601	0	0	张宇	ef70ce5167f429326574b0d9ba74af37.jpg	2	teacher	$2a$10$gw9K5Ng2BNltZttWuLas5OcJCLCbibAedC4is7PbuQSaAqoYtwVrC	640a588bfc5b8af8e469260437a4e972cc7b5fb5	十一中优秀数学老师	\N	0	数学	高中	\N	t	\N	\N
11	51810678@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:50:47.621261	2015-05-05 09:35:16.453734	0	0	王向	0176438bb499489229a1a50528838b53.jpg	2	teacher	$2a$10$id7Ex3vCnxqGe5edMczsV.oMz5e5Bn9Gxfi5B4tj3NU.3s6chMIxW	01ca44c15e0e6520d87245111338ca7475dca9d1	十一中优秀物理老师	\N	0	物理	高中	\N	t	\N	\N
48	704327640@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-04 16:33:35.850075	2015-01-17 05:39:35.71349	2	0	王赛	76b9874f5c810e3520a116c5f8f29394.png	\N	student	$2a$10$X/BhS2KNzk2XHqxdpiQeheP7uo80PWvN.QaQQvU5kD6rnj5i1kGp2	7311d370bedc97698b1bd8ce93a863530a6672fd	\N	\N	0	\N	\N	\N	f	\N	\N
53	sxyqqbg@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-02-02 09:14:46.411973	2015-02-02 09:18:34.320105	0	0	乔保国	fd6ec66a0b36b335ab19c154f2989f77.jpg	\N	student	$2a$10$LkrwzUTqT2676AP1V2XlieQUfitM5Ce6VAlKbH3Vmw.Uj5tQJvdlS	eb96be6c146cfa0c5a2f8795728d0f7d9390d52e	\N	\N	0	\N	\N	\N	f	\N	\N
56	zhjc2005757@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-02-22 14:53:40.555785	2015-03-01 11:57:58.742772	0	0	zhjc2005757	6f8e3f0e9b63ceb4152eee534d595555.jpg	\N	student	$2a$10$1rH8nPy60lxlssoqNL7JbOXCeR/h6rD/T7iyREAFWTofavXYeuwlu	bb3af3a38a97bfdba49bae4e1c5a0105183ea6d1	\N	\N	0	\N	\N	\N	f	\N	\N
49	j_allen_ai@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-05 02:47:16.181404	2015-01-05 02:47:16.532628	0	0	张昊晨	d9e09483684aff4ddfa5f59f90af8501.jpg	\N	student	$2a$10$vsW6r2SdsS8OSOuqXqeQU.I9IP0OY6/vvrx6poT4G0Vt7o88.cs7.	0d562af35ca102cb709c4b609cca21c3a6293986	\N	\N	0	\N	\N	\N	f	\N	\N
46	635057365@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-04 12:17:05.350371	2015-01-06 13:41:23.594027	0	0	周圆	ef9d3f2eeee327be670bf28f32140fdf.jpg	\N	student	$2a$10$ijdZpKNESyYmgGRzzJLh6eQSM9bJczpUwch2CrqXXPnPio/aKPGVu	6cc9e1edbe6c1e83cbf300c6cdf50e160a8c4404	\N	\N	0	\N	\N	\N	f	\N	\N
20	525470795@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-30 02:41:47.050279	2015-04-09 23:06:40.46475	0	0	张宝龙	7f17d8ddaca6125bc604e7897925e937.jpg	2	teacher	$2a$10$xEkWfusU987gLzsnLXLd1.EWxThhBpBN2Bw/1gaIwqbTfTXsMjvLO	c92601ced016584968aa5b97dd36283569243791	十一中高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
28	Hx-lxr@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:26:56.919896	2015-04-09 23:06:40.502351	0	0	李秀瑞	6cc9ace3b69c0e34402db2f21018b13a.jpg	4	teacher	$2a$10$BhvXnNseM.71FvfUQcJEB.FWtacld7T5a20kycmQWiQj6B.V/yJUm	75853117ed049a4776c970bf2184c498cd4f5dbd	阳泉市十四中高中部优秀化学老师	\N	0	化学	高中	\N	f	\N	\N
36	fqb610@21cn.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:34:29.128954	2015-04-09 23:06:40.515182	0	0	付全斌	6414670cb8d50364a0cde936c6b2668e.jpg	7	teacher	$2a$10$wo7x/XUTGed7kN95DZel6e3IEw/BORJFGTacNobsBc66VYtE83WmK	db9abbc0d6193b70601c70bf2813caf432ef974c	阳泉市17中高中部优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
35	jn998877@126.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:32:38.777447	2015-04-09 23:06:40.542026	0	0	张建军	d66aca0d6ab20815dba052aba0a09d47.jpg	7	teacher	$2a$10$.lDZqSFEsNWjDh5XVj98gOVFTR6lPO515yZBpzNqXPgwyH4DSy0nu	211ef76dd9be9311ff62b20c75fdc3d72f9ac95c	阳泉市17中高中部优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
39	35092925@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:43:07.349811	2015-04-09 23:06:40.555131	0	0	郭颖	34bc3c1e3c6084a060f233a843015564.jpg	7	teacher	$2a$10$8w/V7IGTU1cm8yXo7hQdnerBotBn2sPbqZc9ri.MqhuDwJNtdcHa2	374a4f70add811f8768cc82e7807d104d68cf8a2	阳泉市17中高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
40	dayanxlz@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:45:09.332623	2015-04-09 23:06:40.568174	0	0	梁迎花	e43fc72e6a1f4b4315c00191c1b884db.jpg	7	teacher	$2a$10$Zm/KV9QCQcYHdI3i33Xfnuz2dn0KIj2V2FJ3N05h0M7K7.Bv.Mscy	3665fc40eb913646e9d0144065e42a587cf2586d	阳泉市17中学高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
38	guoyj1969@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-11-06 07:40:22.121958	2015-04-09 23:06:40.584192	0	0	郭永金	504712beaa12b163c129a66199df7080.jpg	7	teacher	$2a$10$03gnFvbJiwRpR27.y2hYBucZYkMmMfLq6GxkEg0ycJluM7sifhQjW	4af311e472d6455d9dac2ee0eb277fa1b78daf28	阳泉市17中高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
6	machengke2008@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-28 09:31:59.664127	2015-04-14 10:20:22.437864	8	2	machengke	64eb478ef9d36c9459de71b59cbdf64c.jpg	\N	student	$2a$10$APAeFy1I.UXrQwhZEn6Adur3nOW2YB56UpB/MlE85lC9hHMxHtzaa	11c876b5a48db0c17cca41295e1a554400f446d2	\N	\N	0	\N	\N	\N	f	\N	\N
24	kukafei003@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:05:09.010468	2015-04-14 10:51:17.118169	0	0	陈凯	3aadda668b4e949be10813f030266464.jpg	4	teacher	$2a$10$E3ypkF1EMCP1swzxcNsAhunPC1vetey1HrSK56P3EB7E9tGjFZTku	f9a7d2e78c21aac1cfa613f05212bccef75ddc5a	阳泉市十四中高中部优秀数学教师	\N	0	数学	高中	\N	f	\N	\N
64	zhangyang@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-13 00:59:28.098107	2015-04-13 02:12:28.260914	0	0	张扬	\N	\N	manager	$2a$10$q5Eou4UiZcewp.4z2pfY5uI10XNWFJlAK0d1fHWxfHnIZb3KdiqG6	d54518aaf9d9825366c987cf860125a0e778e7c7	\N	\N	0	\N	\N	\N	f	\N	\N
42	machengbing2015@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-12-05 09:20:44.429273	2015-04-13 10:21:20.878447	0	0	马成兵	e53b0f02ea75043b901c185c064fec03.jpg	\N	student	$2a$10$2.d3QxixNf1OFnoFGCXhdusJms5.AS0bmoHMSHkYHfgdT/aaiaSYq	3c56140de52bc499b02bdba6189aa691a5de0c76	\N	\N	0	\N	\N	\N	f	\N	\N
63	15110872272@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-12 13:37:38.865645	2015-04-13 13:04:33.823787	0	0	王永泽	f3d8c6c94f3f6410641a6a4b7cab931d.jpg	11	teacher	$2a$10$XVwnqWUaGP06l4TnTZ9hG.8SHGS.NR8IbZ6FvwMq95rxj/ECXWTfi	0576dfcdb3fe5923d6ed0f4097f8d57773dbb1ad	从事一线数学教学工作多年	\N	0	数学	初中	\N	f	\N	\N
32	shbch727@sina.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-31 05:02:00.479081	2015-04-09 23:06:40.13211	0	0	石宝成	a30ca00a2a3abf51f1806bff111b723a.jpg	2	teacher	$2a$10$dc1zTH7svSrlC6t3ybEg.OFYMiIfX3HICC85dkUNe3APptfLoH5IC	222423c129b2f377aec12edc759cbc2928b8c9af	阳泉市十一中高中部优秀数学老师	\N	0	数学	高中	\N	f	\N	\N
21	517957307@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-30 03:25:37.474799	2015-04-09 23:06:40.16208	0	0	张建忠	004d0f770cf9e0864873aedd2ebf6687.JPG	3	teacher	$2a$10$tDBTH11r5p1rWEHkMLHoLO7HipB3mD/NBzh4hivm4ZX8WhidB8vBG	0701f4dca9b6c5d67c3a8a9b1ca09ab7e76ef6f6	外国语学校优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
29	zhaoyumei@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:32:17.529293	2015-04-09 23:06:40.373676	0	0	赵玉梅	a4dc9b7385c9c9e681ee2458b9074ec7.jpg	4	teacher	$2a$10$ZbMOHMboQVeJpUaUyX6EJuvF5Ax1kG7Q3TPWD4dcgmk5QhLZQgswG	87f5c12b28dbd54d79ad46f70c8c48bcc2011f7e	阳泉市十四中高中部优秀生物老师	\N	0	生物	高中	\N	f	\N	\N
62	1142894321@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-12 12:59:24.228952	2015-04-12 13:11:36.439591	0	0	张延明	95ea2d06864c29b369d55cf72ea26fcc.JPG	14	teacher	$2a$10$W/TYfgUzbMC4stsIDZGuf.fNa3Ux7Zkc8.oKDL5.L65APqmutmCI6	b9ad1a6be9657d3e5fc0ff092250af6030f80cec	张延明,中学高级教师，阳泉市第十五中学高中数学教师，特优班班主任，数学教研组组长，教学经验丰富。	\N	0	数学	高中	\N	f	\N	\N
50	1033384853@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-01-09 11:00:23.721047	2015-04-13 01:25:54.389321	0	0	王永泽	5db8d4e7b7a5aa19ff0fdaf399f19655.jpg	\N	student	$2a$10$PiT9zAVZdW9zzzMIA.gUp.XiZGeUEpQI7PVQ2dCbD7tmTeimT6je6	6aa3908524aecbc379c9da32b855c77194d960aa	\N	\N	0	\N	\N	\N	f	\N	\N
59	zhang..xian@163.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-12 02:05:15.378945	2015-04-13 13:07:12.171254	0	0	张贤	3e2a9f041e395bce50214c511a4aebe0.jpg	9	teacher	$2a$10$VkZo2DNbDmUP3ZNrhBC8HueXf07RgX6dcdlcUAmZEsciY2tm7a6nC	6543eae148152cc38b840281b01de41af9402410		\N	0	物理	初中	\N	f	\N	\N
60	yangchlove@126.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-12 03:27:44.424545	2015-04-12 03:37:57.905476	0	0	杨超	d2760c46444a9a3e94d1f831efe8e8b7.JPG	10	teacher	$2a$10$HufYJahXh2XEjipsuOK2quZjdC5ZtmCNxVbwxEqPKMhboch2mwXca	4ec8c7cc85274916ecd07927e9349d308f079220	从教二十年，对初中化学的知识点、难点了然于心，授课深入浅出，解答问题重点、难点讲解透彻。	\N	0	化学	初中	\N	f	\N	\N
26	jyf19721022@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-10-20 02:21:16.084856	2015-04-18 05:05:39.448082	0	0	荆毓富	c480e8dfd957f89024cad951c622160f.jpg	4	teacher	$2a$10$FHeFRzOjUQVDT9l/6NiCJetU1LM1XkVw.KBD49Uov9SNltCDSO/6C	09f1a673e8556d900f8d96c812a3beb0832d3e7d	阳泉市十四中高中部优秀物理老师	\N	0	物理	高中	\N	f	\N	\N
61	707713378@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-12 12:04:24.04326	2015-04-18 06:38:09.106485	0	0	梁瑜	4436918e9757e6f359571c317cd11e04.jpg	\N	student	$2a$10$odgVi168IgeB5UFtA0N02ON1FfSt6i50FEvEvwje/lXdBkw6tayZK	1a93b8b2a390313b86b990622135a018bd39bcbb	\N	\N	0	\N	\N	\N	f	\N	\N
65	99488898@qq.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-13 02:23:54.253161	2015-04-19 09:10:04.409229	0	0	徐林	065411d4dfe1c7ed3920c084759f071c.jpg	13	teacher	$2a$10$boGn7kKmXkXu8svDbNQmx..k.8E3sSQB/Wp7B4i19eNcYbRNA3q0a	3b6c17522f6dfedb4fa38358183ae14693c5c17f	       本人于2005年7月毕业于忻州师院应用数学系；于2011年7月取得山西师范大学应用数学硕士研究生学位。从2005年9月至今一直从事高中数学教育工作，具有丰富的教学经验，形成了自身完整的教学理念。熟练多媒体教学操作、课件制作。对学生真诚热心，并能因材施教。2008、2010年荣获校级优秀教师；曾发表论文《多元统计分析在学生评教中的应用》（西南农业大学学报 2011.04）、《我国各地区城市设施水平的多元统计分析》（北京电力高等专科学校学报 2011.08）、《创造良好氛围 提高数学课堂效率》（北京电力高等专科学校学报 2010.11）以及论著《线性代数与几何理论及其应用》（ 副主编 吉林大学出版社 2013.10）。	\N	0	数学	高中	\N	f	\N	\N
70	t2@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-19 23:25:07.033747	2015-04-19 23:26:09.802591	0	0	t2	fa718e6a4115745ae2805c63c16767bd.jpg	2	teacher	$2a$10$B89fFDcr0TGskViAxwqK7.7FUvgT4fQGnekVAL6PXCdvbQhdTgzAa	6cd441dc6108edee759e1d0af8d341e691b12076	asdfasfasdfasdfasdfasdfasdfasdf	\N	0	物理	初中	15910676326	f	\N	\N
68	t1@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-19 23:08:39.190977	2015-04-20 22:07:25.899091	0	0	t1	47c4b433d738e5cd549f72cdc6bf5698.jpg	1	teacher	$2a$10$DuSzUj7xlxn3BjJchBa7a.D1iPGkbkIZ2zOtoFPQEVaWmCNcfCMy6	375befcd0463ff3cbeab2fbc6d674676c307210c	kkkkkkkkkkkkkkkkkkkkkkkkkkkk	\N	0	数学	高中	15910676326	f	\N	\N
8	xyz_east@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:44:45.801062	2015-05-05 09:34:57.302367	0	0	刘飞	d03dc5fe50243071e420d4eb26239c78.jpg	2	teacher	$2a$10$pDGkw4y1QJFJtY5mpvq3JO0yT3Y9f1Jy/epKGlJ8eTQZ1MBt2VKOu	98f6fa403a5d8ece0ee6c15955dafe17376d380e	十一中优秀化学老师	\N	0	化学	高中	\N	t	\N	\N
12	xxiaorunhua@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:53:05.62796	2015-05-05 09:35:20.717409	0	0	肖润华	669d1bfaae40dcbc0964961f3cfe0f43.jpg	2	teacher	$2a$10$zvWMZNb21RmfnsJ.pR8beOLhbHf93DwNat2fg0VLCiBAOcymtbWsi	eb99cfedd3fd8aae1aa556c431c72e69e17e3a50	十一中高中部优秀数学老师	\N	0	数学	高中	15910676322	f	\N	\N
72	s2@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-19 23:50:43.50291	2015-05-16 23:59:03.608771	0	0	s2	72daaaccc017d894524968910c403676.jpg	\N	student	$2a$10$e7M..OsarFHfEFMLgGmAG.Yow1TuiMRlxROo0ZYMDS8/qiPKb2pC2	4d051162c44602fd20608e19bfcff569f2a268be	\N	\N	0	\N	\N	88888888888	f	高一	\N
73	s3@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-19 23:52:44.062082	2015-05-18 11:17:59.323933	0	0	s3	4edce29021b66f08f045b12cde48591c.png	\N	student	$2a$10$MPmO5rApFDCOw0VeuW.lnerE5j4.JEJMagSTQCdydQEGLvsbxr8Ce	6733abe81aa728e0c8db2c31f49cde86b42895fb	\N	\N	0	\N	\N	88888888888	f	\N	\N
7	swx369219@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-08-29 10:42:58.041025	2015-05-05 23:39:13.752661	0	0	孙文秀	0afdf4d38ab56b22fc0a28c579934078.jpg	2	teacher	$2a$10$8cLU3wHi4doc5JrMeAxXNO18D4Rs9aRfuAkv3fZQlpilUugfuQ6gG	00c0c27be11f9e9e8d82f6255f236f0f52c06896	      从教35年、中学高级教师、山西省中小学模范教师。所带班级屡创佳绩！在2011年高考中，所带的实验班240班（全班49人）有21个人达二本线以上，达线率42.9％,是上级计划达线人数的175％，5个人达一本线以上，达一本线率10.2％，还有一个达了艺术类一本线，创造了我校同类班级的新纪录！在2014年高考中，所带的实验班277班（全班66人）有37人达二本线以上，达线率56.1%；一本线以上7人（其中550分以上6人），一本达线率10.6%；2012年分到本班年级前250名36人，所以2014高考有效达线率103%，再创学校同类班高考达线率新纪录！\r\n       曾获： 山西省：高中课改三优工程《任选课》一等奖、《教案》二等奖。\r\n                                 2011年教师节荣获“山西省中小学模范教师”称号。\r\n                 阳泉市教育工委：优秀共产党员；\r\n                 阳煤集团：先进教师、优秀班主任；\r\n                	\N	0	物理	高中	15910676326	t	\N	\N
74	e@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-05-09 11:30:06.665628	2015-05-11 23:24:29.712041	0	0	333	0317710ba088e795b862a14adb208b7e.png	3	teacher	$2a$10$h3YasYZxoBvwr93GSeVwZe6qbGkJqNXgdVSE8tYmWcr/uTplxfxem	ee1424cc53cb02849aac41347d586a44f421fb59	3232323323232332323233232323323232332323233232323323232332323233232323	\N	0	英语	高中	11111111111	f	\N	\N
58	machengke@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-04-11 08:16:44.673629	2015-10-10 13:26:34.186083	0	0	马成科	5950164eefd0372b42376213c9b52c4b.png	\N	manager	$2a$10$A4/9bWMF466q/dsw4HoVPuMcbySa5WP6DzkTLjzHxfh1lhjoc4/uG	f88509129e6061ed6a9197ba752850627460622a	\N	\N	0	\N	\N	\N	f	\N	\N
2	zhang@163.com		\N	\N	\N	0	\N	\N	\N	\N	2014-06-25 12:21:44.269794	2015-10-10 13:29:20.984519	14	1	张建东	ba61da898d301eb96e72f5a2a34f1e80.jpg	1	teacher	$2a$10$xUVjT1nRp.F5D3.HbuH3R.Lxqj9SHmN6B62W2oXtcx3K32J2YVvRW	2ddeb274dd1d70612cf998ad1da1d76a6ad5e328	张老师是测试老师，账号是用来测试的.	\N	0	物理	高中	15910676326	t	\N	
76	a@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-10-10 13:31:39.969233	2015-10-25 00:09:50.616359	1	4	aaa	726aea7591089e1c851099451ec316d5.JPG	1	teacher	$2a$10$an8ULUTI.zvjppnRCHfNP.2ec7bFNhUlxUeYc7e44CR2tAOt9eChS	748daf879f1b3fe00f1660dad87709cb1d824d9c	asdfadsfasdfa	\N	0	物理	高中	15910676326	f	\N	aaa
75	z@qatime.cn		\N	\N	\N	0	\N	\N	\N	\N	2015-05-18 11:21:11.205946	2015-10-25 00:15:59.501036	12	6	z	5d7a99562aa61d0b40c763691a7c824e.jpg	\N	student	$2a$10$udltfN82atLbyZCipta3wOUAuDSie.owyMMGDjVQnmyqxBJXmfhoC	04e5f2b4f79d10e578939d386b66ebd1f400623f	\N	\N	0	\N	\N	15910676326	f	高一	\N
57	chuanjiabao1981@gmail.com		\N	\N	\N	0	\N	\N	\N	\N	2015-04-09 23:11:10.348818	2015-10-25 00:16:17.897923	5	11	admin	\N	\N	admin	$2a$10$sRIPw7gFfGtBPB4qJsmLyejlKHUPr5Nf7OQdHNAeC/FkHFCZ4W0zK	eda34d8ca11fc1d670762a7eaae4ecef64683f28	\N	\N	0	\N	\N	\N	f	\N	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('users_id_seq', 76, true);


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY videos (id, name, created_at, updated_at, token, videoable_id, video_type, convert_name, state, videoable_type, author_id, duration) FROM stdin;
283	\N	2015-08-27 06:14:19.992513	2015-08-27 06:14:19.992513	1440655999-d2DDowtINX9fwJ02wS_K1A	23	mp4	\N	not_convert	Answer	2	\N
284	de8d00857fcbc6de936f006c5aa97809.mp4	2015-09-15 12:21:54.335847	2015-09-15 12:21:54.661675	1442319687-o22m01dV_CVUSx5Lmi4qNg	\N	mp4	\N	in_queue	\N	57	\N
285	34cf110b24d90ecb504ada4d93b1f160.mp4	2015-09-15 12:23:07.186589	2015-09-15 12:23:14.495799	1442319778-22x2ktceTNNj6w78eGIEEA	1	mp4	\N	in_queue	CustomizedTutorial	2	\N
286	f7ea127f58e749d3826677c9d64ab925.mp4	2015-09-18 05:30:53.970978	2015-09-18 05:30:54.495355	1442554232-FkEaZV_ddc1ub-Ue6jWsqw	\N	mp4	\N	in_queue	\N	2	\N
287	cd87fb687b62e353c9ca1e2a5897fb52.mp4	2015-09-18 05:40:58.279391	2015-09-18 05:40:59.297064	1442554827-cDRc6FRV8hUCL6tkL1USgQ	\N	mp4	\N	in_queue	\N	2	\N
288	93e3e5bd95313699e7c8a1a54086cb67.mp4	2015-09-18 05:42:17.444758	2015-09-18 05:42:18.241514	1442554864-i89ugCfQaLLVR4GGGlnkKw	\N	mp4	\N	in_queue	\N	2	\N
289	41066591a320f458f1b38a06f1dc837e.mp4	2015-09-18 05:54:51.491115	2015-09-18 05:54:52.571072	1442555672-pBGfIPbIaWYRzsQAUqn6IQ	\N	mp4	\N	in_queue	\N	2	\N
290	cd48c17eb0bd445b8c0bad0a068fb08c.mp4	2015-09-18 05:55:09.232543	2015-09-18 05:55:10.009153	1442555694-lKtV4Kz4d2SZJbshMZBTig	\N	mp4	\N	in_queue	\N	2	\N
125	a5a7688b5c4dd58f2ef58b921a2a2e07.mp4	2015-03-29 13:50:10.007605	2015-03-29 13:50:10.007605	9dwx-RmFnS9h7KqYwJMirg	\N	mp4	\N	not_convert	Lesson	\N	\N
189	f4ede0f235557413c5846f8dfc4988b4.mp4	2015-04-27 23:04:41.409373	2015-04-27 23:04:41.409373	Yb5eXEfG7Y5IO5d8u3TOVQ	\N	mp4	\N	not_convert	Lesson	\N	\N
191	a50f37ce0451bec446b3aca0697979ce.mp4	2015-04-28 22:46:24.046364	2015-04-28 22:46:24.046364	1_VjhNkNoFNI6JoeESGY5w	\N	mp4	\N	not_convert	Lesson	\N	\N
14	db737eb0e7d835ad41e023bd67d6efc1.mp4	2014-06-28 01:07:44.445905	2014-06-28 01:07:44.445905	mICPB-HLqIkyv3rg2dETgg	\N	mp4	\N	not_convert	Lesson	\N	\N
15	2266361e7e015fef3b3683c03beca42b.mp4	2014-06-28 01:11:50.889838	2014-06-28 01:11:50.889838	mICPB-HLqIkyv3rg2dETgg	\N	mp4	\N	not_convert	Lesson	\N	\N
17	b5bd55a0f30605a912c09c617f828e33.mp4	2014-08-07 14:05:41.143035	2014-08-07 14:07:29.28843	V6tWdOlnQPpjzTDjhuPjrg	15	mp4	\N	not_convert	Lesson	\N	\N
18	767b7843f6ceffac7c077622dbf02f74.mp4	2014-08-07 14:16:00.625121	2014-08-07 14:16:32.283756	Uwn5cuO9hbywue99lpGIww	16	mp4	\N	not_convert	Lesson	\N	\N
20	3c9e16d7cbaca962103e397eb554dd1b.mp4	2014-08-07 14:42:48.951581	2014-08-07 14:42:48.951581	k7ef0L_YnhsP9wyoqbnYBQ	\N	mp4	\N	not_convert	Lesson	\N	\N
22	375394378cd949721644daa03ebb8249.htm	2014-09-02 02:36:59.589808	2014-09-02 02:36:59.589808	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
23	ec6594370831ed637eec81c8f7ba3f47.htm	2014-09-02 02:37:11.340674	2014-09-02 02:37:11.340674	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
24	b7bf472f9defe698a8c8c9bf385002ac.htm	2014-09-02 02:37:18.067154	2014-09-02 02:37:18.067154	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
25	78b96d142389f9b9cb46b25c89fc6d09.htm	2014-09-02 02:37:24.314217	2014-09-02 02:37:24.314217	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
26	e0e5dfa5e396f2f8841f0a63a07b26be.jpg	2014-09-02 02:37:29.500459	2014-09-02 02:37:29.500459	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
27	7ec07d23c3e8ff6a7248533eba96e217.jpg	2014-09-02 02:37:33.821118	2014-09-02 02:37:33.821118	L-6Ad1xccAWJDvJfG1hEdw	\N	mp4	\N	not_convert	Lesson	\N	\N
29	9079339717ca5488cb30e5bfd8b57c8c.mp4	2014-09-20 07:12:58.992251	2014-09-20 07:12:58.992251	amg8WqjYxdkzHjyj-hbLkw	\N	mp4	\N	not_convert	Lesson	\N	\N
32	e11c27687949fda822ff4449651b0da6.mp4	2014-10-06 07:51:21.608136	2014-10-06 07:51:21.608136	1cxT_mlSl8AeO4TTwzz-sA	\N	mp4	\N	not_convert	Lesson	\N	\N
33	790688a3f4ca1ea3ef3f5aa14886f8b3.mp4	2014-10-06 07:53:01.38286	2014-10-06 07:53:01.38286	1cxT_mlSl8AeO4TTwzz-sA	\N	mp4	\N	not_convert	Lesson	\N	\N
34	1bfe84eff0e019e5059e538286737c64.mp4	2014-10-06 08:29:24.32919	2014-10-06 08:29:24.32919	4EiV16UlbsyxFQ89hQuKYQ	\N	mp4	\N	not_convert	Lesson	\N	\N
35	694b7d524b3053bcbb7c1bb5552dd515.mp4	2014-10-07 03:07:41.774092	2014-10-07 03:07:41.774092	E9qGVhjeyRazMO3azcbepg	\N	mp4	\N	not_convert	Lesson	\N	\N
37	62a14c8785f8691da1f27fb75a94cf65.mp4	2014-10-22 12:00:31.353685	2014-10-22 12:00:31.353685	zq_O1KFspORC1yO4haJigg	\N	mp4	\N	not_convert	Lesson	\N	\N
58	5b47ab9c5c4fd1bf321fd1de627277df.mp4	2014-11-02 05:58:46.626271	2014-11-02 05:58:46.626271	TD-WBhY5aFKg_kzlDh81Jg	\N	mp4	\N	not_convert	Lesson	\N	\N
41	0812c1745d62030f1f3cb097be5cd21e.mp4	2014-10-23 04:38:50.295133	2014-10-23 04:38:50.295133	ghi28rXI4jMIomQU9JjMYw	\N	mp4	\N	not_convert	Lesson	\N	\N
42	b83c7d48a9060ffd8b0bfba1e17202dd.mp4	2014-10-23 04:42:27.656165	2014-10-23 04:42:27.656165	_IAO87AEYctC051Ka0xf3Q	\N	mp4	\N	not_convert	Lesson	\N	\N
77	08d993de482e7beaefba92d0ef22eb85.mp4	2014-11-16 02:49:59.07944	2014-11-16 02:49:59.07944	IVz8Eoy_U8ZkVmzkBNBxkQ	\N	mp4	\N	not_convert	Lesson	\N	\N
80	5b3f0f18332f587dd79b57a4856518d2.mp4	2014-11-16 03:06:28.861985	2014-11-16 03:06:28.861985	VFpAwHziOPqkmK2rZrLBvQ	\N	mp4	\N	not_convert	Lesson	\N	\N
81	f2467791cb5a2b874f347a42fd4b83e0.mp4	2014-11-16 03:07:27.708772	2014-11-16 03:07:27.708772	AMZXhySj_Y0-dxlr2k-GbA	\N	mp4	\N	not_convert	Lesson	\N	\N
82	0e909a43c59882738c2be27c2a0b2da2.mp4	2014-11-16 03:18:08.434016	2014-11-16 03:18:08.434016	5DkA77G4tzAydwafXZJD7Q	\N	mp4	\N	not_convert	Lesson	\N	\N
79	cceb0283ff7156373da82c3c943c49c3.mp4	2014-11-16 02:54:52.196916	2014-11-16 02:54:52.196916	QpOgZK_HYL_QAhXMVZcDDg	\N	mp4	\N	not_convert	Lesson	\N	\N
83	9145fdaedb95c85605623a8bdb456a2e.mp4	2014-11-16 11:07:21.469577	2014-11-16 11:07:21.469577	nnQdd83clL_83o8tEBEBQA	\N	mp4	\N	not_convert	Lesson	\N	\N
92	3a3192c4913f94c2636055f684131de8.mp4	2015-01-12 14:22:49.761648	2015-01-12 14:22:49.761648	PI2UB504TXYeemhKiqJw7Q	\N	mp4	\N	not_convert	Lesson	\N	\N
102	9cd8ed76bd810e7abbebf6690c697d55.mp4	2015-03-11 16:27:35.871908	2015-03-11 16:27:35.871908	cH1Y59zkl0FUPQrAAqNBHg	\N	mp4	\N	not_convert	Lesson	\N	\N
120	40cd9effe156a29fb6cde015014ad1ad.mp4	2015-03-23 04:34:21.808112	2015-03-23 04:34:21.808112	LRxakPPaP6Sxyf1G_p-DEw	\N	mp4	\N	not_convert	Lesson	\N	\N
123	46fe007c46b3b2a4bc8996591cfe70f8.mp4	2015-03-24 04:59:05.956813	2015-03-24 04:59:05.956813	Q8ayfnC3IdzixR3HwEZigQ	\N	mp4	\N	not_convert	Lesson	\N	\N
127	1c5f9090464a99ad2538c3e304fabf61.mp4	2015-03-29 14:11:42.449489	2015-03-29 14:11:42.449489	OYQ20ekiydLyo1K6_fKiVw	\N	mp4	\N	not_convert	Lesson	\N	\N
129	4c01bda67facb80264344fdff775e0f1.mp4	2015-03-29 14:27:35.681634	2015-03-29 14:27:35.681634	S_PEUf43IV4WO2JcYcO2-Q	\N	mp4	\N	not_convert	Lesson	\N	\N
141	5bb13ad4cfbb69a06d214600fa2cbffe.mp4	2015-04-13 12:14:21.07439	2015-04-13 12:14:21.07439	OBWhV8F21M5QxDEINu42Jg	\N	mp4	\N	not_convert	Lesson	\N	\N
144	a99bd989c7c3c90e93af4932deb3a719.mp4	2015-04-15 08:31:18.118931	2015-04-15 08:31:18.118931	5Kzv4c4tzCD3OD2t4VpdkA	\N	mp4	\N	not_convert	Lesson	\N	\N
145	1f03df8851a1bde8cc8b8229623d58f7.mp4	2015-04-15 08:35:56.607343	2015-04-15 08:35:56.607343	5Kzv4c4tzCD3OD2t4VpdkA	\N	mp4	\N	not_convert	Lesson	\N	\N
146	ed8d3485e4c30f3e17e5ca3111578c94.mp4	2015-04-15 08:37:43.846577	2015-04-15 08:37:43.846577	BGLITh4LJVgdadUKZOcTWQ	\N	mp4	\N	not_convert	Lesson	\N	\N
147	d16cdd0303ff380b1f6cd6a8c0afa959.mp4	2015-04-15 08:40:38.335274	2015-04-15 08:40:38.335274	8cVOdw2OM4V3ekYiwPPkFA	\N	mp4	\N	not_convert	Lesson	\N	\N
148	ea89d8dc919e32aa338b0cb4a9d63b9c.mp4	2015-04-15 08:45:14.168559	2015-04-15 08:45:14.168559	Zwtayh4KOJcJ1W7RPiyFQg	\N	mp4	\N	not_convert	Lesson	\N	\N
149	cbc22a980dbeeefe16097afcfccc3080.mp4	2015-04-15 08:46:44.71657	2015-04-15 08:46:44.71657	jh0ljBsBLpqZnYvbHC6tWw	\N	mp4	\N	not_convert	Lesson	\N	\N
150	c613048ef9f2f2ff196a5e355422cf49.mp4	2015-04-15 08:47:52.333901	2015-04-15 08:47:52.333901	5ySATAaLYLdiZj-MYS1s1Q	\N	mp4	\N	not_convert	Lesson	\N	\N
89	813f5528eca87b1f83494f66e39b5424.mp4	2014-12-15 00:33:43.010392	2015-08-24 07:40:14.096156	IMCKHXSuVW-IaLN2HykaYQ	46	mp4	\N	not_convert	Lesson	33	\N
90	8596ed6f4a830b2596054d81d3c87221.mp4	2014-12-29 01:30:50.261643	2015-08-24 07:40:14.108612	T9NxvLU1ZheE5r9I-DhqEA	47	mp4	\N	not_convert	Lesson	7	\N
114	a17d282e85a8731e87abe96e802e1cde.mp4	2015-03-23 04:13:42.438531	2015-08-24 07:40:14.117646	bNoNuZxbwwFyBTvrBxM-_Q	69	mp4	\N	not_convert	Lesson	26	\N
93	66127ce2256ea25b957c555381ef0290.mp4	2015-01-12 14:24:14.624131	2015-08-24 07:40:14.128423	FHpGXrdF2gXevyouOBzYFg	49	mp4	\N	not_convert	Lesson	26	\N
94	c51c0342230e1ab87324565a8c887445.mp4	2015-01-13 08:31:59.785167	2015-08-24 07:40:14.139902	HlDM4k9ZKPa_aWL5Qrdgdw	50	mp4	\N	not_convert	Lesson	21	\N
95	9d280532803966a84b418d1c527db208.mp4	2015-01-15 05:30:08.273332	2015-08-24 07:40:14.151266	v-KF2LkIcgF_VN3mrVI-GQ	51	mp4	\N	not_convert	Lesson	7	\N
211	82cc3a34d59801bfce9262c1db2d6f54.mp4	2015-04-29 22:01:14.18355	2015-04-29 22:01:19.74604	FIsQ23rxBJrBppcnhZAVOA	\N	mp4	\N	not_convert	Lesson	\N	\N
244	989680354b026026612248c5ce4e1f2e.mp4	2015-04-30 02:11:53.954772	2015-04-30 02:14:34.886416	lCPDDZmI1nLWeexqCSeT5w	\N	mp4	\N	not_convert	Lesson	\N	\N
264	83b393dd264ce57d2609a7cbb400583b.mp4	2015-04-30 22:51:35.811582	2015-04-30 22:51:37.131429	hJld9heb8m3EaA5ZE57MWw	\N	mp4	\N	not_convert	Lesson	\N	\N
253	0c1a299d007241cdd04e49dd3ae216f2.mp4	2015-04-30 22:30:10.316459	2015-04-30 22:30:11.255437	OATOpjy3nW0hOG-8b3FKIw	\N	mp4	\N	not_convert	Lesson	\N	\N
254	b6a41f30ebf6b6dd0c0b11898ae113ea.mp4	2015-04-30 22:31:45.212481	2015-04-30 22:31:46.534999	tzSUNZO6oeU86AYsVjGPzQ	\N	mp4	\N	not_convert	Lesson	\N	\N
255	14dc783d02c2f2ec4779a4630005dfcf.mp4	2015-04-30 22:34:21.940228	2015-04-30 22:34:23.007964	mwQyQBQKBBxLKGyh3rQrcQ	\N	mp4	\N	not_convert	Lesson	\N	\N
256	a0c6aa954d88e86803956c28eb9293f6.mp4	2015-04-30 22:35:59.215278	2015-04-30 22:36:00.463089	944jyI5hlkPOFhaCG5FmAw	\N	mp4	\N	not_convert	Lesson	\N	\N
257	5e8cb1d1c00672df4a0f92b14e67fe8d.mp4	2015-04-30 22:36:18.224152	2015-04-30 22:36:19.140389	orYeaJkLVYz9kcAKP_Xltw	\N	mp4	\N	not_convert	Lesson	\N	\N
258	e7a0b68daf50aecab27e23c289f5515c.mp4	2015-04-30 22:37:36.572579	2015-04-30 22:37:37.780516	-C7JGuVr7M4tNqAVf7JAHw	\N	mp4	\N	not_convert	Lesson	\N	\N
259	ea15a3f95d0e439a1541ec984541f6fb.mp4	2015-04-30 22:39:58.797347	2015-04-30 22:39:59.946973	IhpZTzXGcl-gBorw1i95DA	\N	mp4	\N	not_convert	Lesson	\N	\N
260	ce37060ab02a58455097f009570a6958.mp4	2015-04-30 22:40:31.487765	2015-04-30 22:40:32.435954	47UcXa3R1iPzYkWRl8Iu8g	\N	mp4	\N	not_convert	Lesson	\N	\N
261	c2c756b848e616b42af07c2944776943.mp4	2015-04-30 22:42:53.456906	2015-04-30 22:42:54.304016	UsAIapo0AR1opqgmx6GnrA	\N	mp4	\N	not_convert	Lesson	\N	\N
43	a564f724fa2fd5339c46a835448779c4.mp4	2014-10-23 04:46:04.321082	2014-10-23 04:46:04.321082	1RzaM2GQ6BVHN-W4nLOSYw	\N	mp4	\N	not_convert	Lesson	\N	\N
44	abfaa0f39247aa6b9f1f3adbbf11c17d.mp4	2014-10-23 05:00:46.42437	2014-10-23 05:00:46.42437	ccotvDAYJBmYR9UoOrPKCg	\N	mp4	\N	not_convert	Lesson	\N	\N
59	611e55afdb269b4ad0cdf02ecea83562.mp4	2014-11-02 06:14:43.931462	2014-11-02 06:14:43.931462	TD-WBhY5aFKg_kzlDh81Jg	\N	mp4	\N	not_convert	Lesson	\N	\N
48	b29f524417893a48554ec19f42bff976.mp4	2014-10-28 14:35:46.732056	2014-10-28 14:35:46.732056	bgtakGqrgvRcCFdyYqhOCA	\N	mp4	\N	not_convert	Lesson	\N	\N
49	ee7a6c4c44518ced9dfa35181bc32a67.mp4	2014-10-30 10:00:37.630551	2014-10-30 10:00:37.630551	ZD87aDvmBhsJdudiwgjjHw	\N	mp4	\N	not_convert	Lesson	\N	\N
51	ac14e3fd9a6164a47a99748a0637fc75.mp4	2014-11-01 01:12:40.996406	2014-11-01 01:12:40.996406	nmHWdY5Gj9tMK27gP9o2Rw	\N	mp4	\N	not_convert	Lesson	\N	\N
52	9fb935dd3bd473a0e23b5822d332f5bb.mp4	2014-11-01 01:17:55.300019	2014-11-01 01:17:55.300019	zsqdo3UBOfKo20bxwRpEIg	\N	mp4	\N	not_convert	Lesson	\N	\N
53	da0035f94241429e1de210801a4da77a.mp4	2014-11-01 01:29:13.688365	2014-11-01 01:29:13.688365	HPpFNn1SKHezJB5DsIcLrw	\N	mp4	\N	not_convert	Lesson	\N	\N
54	d848c659e82dee23db9e987d6b3b4a60.mp4	2014-11-01 02:28:09.852636	2014-11-01 02:28:09.852636	PeR4Ovz1EsGiSW3cSRvmyw	\N	mp4	\N	not_convert	Lesson	\N	\N
55	d98fcfa5432304312bd35530219f01e2.mp4	2014-11-01 07:00:44.025877	2014-11-01 07:00:44.025877	MldwYorK63kYC7am9W9V1Q	\N	mp4	\N	not_convert	Lesson	\N	\N
61	806ae9506326b5963aae3cafc235de48.mp4	2014-11-03 01:16:51.701095	2014-11-03 01:16:51.701095	RZfgycdvEzBRwmBdo5AcrQ	\N	mp4	\N	not_convert	Lesson	\N	\N
63	225c0358c22a5ee1ba43fa9e24f5149c.mp4	2014-11-03 07:37:10.215149	2014-11-03 07:37:10.215149	ow6uLLqDlocZ7WRU-Xzf6Q	\N	mp4	\N	not_convert	Lesson	\N	\N
64	005dbc60d397b85d7e7d1b887e3f22f3.mp4	2014-11-04 09:58:00.341838	2014-11-04 09:58:00.341838	OTm47OOeY_5bzYWUDTp8tw	\N	mp4	\N	not_convert	Lesson	\N	\N
65	2fdbc84bceaa73ea1190b940bc9b9f09.mp4	2014-11-05 03:17:32.846677	2014-11-05 03:17:32.846677	mgAsOVymJQ094XZyx0OEMw	\N	mp4	\N	not_convert	Lesson	\N	\N
66	55df706814015095a73956946295d5f8.mp4	2014-11-06 07:56:44.945756	2014-11-06 07:56:44.945756	lDd5U8FvhRLdXQH5vHwGww	\N	mp4	\N	not_convert	Lesson	\N	\N
68	99c8485f40b73f492280c1b02c51c079.mp4	2014-11-06 08:49:01.151463	2014-11-06 08:49:01.151463	QpQTICqqoqPVRY10ydt74w	\N	mp4	\N	not_convert	Lesson	\N	\N
78	4e628203227fba7bdd0c095def170adc.mp4	2014-11-16 02:54:00.134975	2014-11-16 02:54:00.134975	4cyJuIRctSsof1DtzdUMCA	\N	mp4	\N	not_convert	Lesson	\N	\N
75	d31f2f96ba119210b0500e185cd095d9.mp4	2014-11-13 04:40:42.196317	2014-11-13 04:40:42.196317	6IoQdqrPle6mVQ6dP0wqnA	\N	mp4	\N	not_convert	Lesson	\N	\N
151	634f94aaf3e81e5213786b961569bea2.mp4	2015-04-15 08:50:41.30565	2015-04-15 08:50:41.30565	TjmsqfBt1eiYgP0WgV8tXw	\N	mp4	\N	not_convert	Lesson	\N	\N
152	bea48302931fab5c051672f36d8bafc8.mp4	2015-04-15 08:51:25.96332	2015-04-15 08:51:25.96332	W52qlYfRx5wLNjYsUfoAog	\N	mp4	\N	not_convert	Lesson	\N	\N
153	e2717db3e2219fadc0934a036cc5c95d.mp4	2015-04-15 08:52:39.774165	2015-04-15 08:52:39.774165	skYAZl0dGHUITx7OgDGuzg	\N	mp4	\N	not_convert	Lesson	\N	\N
154	ef4381e622604a0307bb789cd5b226e1.mp4	2015-04-15 08:54:52.410739	2015-04-15 08:54:52.410739	5Q2gd5Bw52yFWdJWcWL_sQ	\N	mp4	\N	not_convert	Lesson	\N	\N
155	0d6e9186f16d74be3d3f939e41cd00c9.mp4	2015-04-15 08:56:41.681111	2015-04-15 08:56:41.681111	N-5SlXjEYtqez2E6nJQnuw	\N	mp4	\N	not_convert	Lesson	\N	\N
156	6aa46517e0a7c0965c229f6ae088025a.mp4	2015-04-15 08:58:26.252626	2015-04-15 08:58:26.252626	nq9whVFKkbURuAXuwom8lA	\N	mp4	\N	not_convert	Lesson	\N	\N
157	7b3eb7fd826c281cc13b9cd621b8c9dc.mp4	2015-04-15 08:59:00.761382	2015-04-15 08:59:00.761382	4MED47LiXHmqa2tmhOxvww	\N	mp4	\N	not_convert	Lesson	\N	\N
158	1c9078c8147fb7586a983c4ad31b1d61.mp4	2015-04-15 08:59:51.821689	2015-04-15 08:59:51.821689	BVEczwhsxGnzsEVXOMnFDw	\N	mp4	\N	not_convert	Lesson	\N	\N
159	7abfca2dbc260f17f3c82173ed7f685c.mp4	2015-04-15 09:00:44.021932	2015-04-15 09:00:44.021932	gpLkJj3_bFGlUzL5RgjdFw	\N	mp4	\N	not_convert	Lesson	\N	\N
160	2348d6192fdacec94e99bd858f73a3ea.mp4	2015-04-15 09:02:05.325197	2015-04-15 09:02:05.325197	ez76FS5WM1ZbciiW7SZucg	\N	mp4	\N	not_convert	Lesson	\N	\N
161	80495bddb8aecb1cf3c613df0b2f95d4.mp4	2015-04-15 09:07:47.906004	2015-04-15 09:07:47.906004	ez76FS5WM1ZbciiW7SZucg	\N	mp4	\N	not_convert	Lesson	\N	\N
162	53d5ab801b2bec4cb607d7c985025d16.mp4	2015-04-15 09:16:28.401811	2015-04-15 09:16:28.401811	OwnTyqX3TnV9Z-JJYNiPuA	\N	mp4	\N	not_convert	Lesson	\N	\N
163	1895e0fc990638c2a688e0c4721c0c5b.mp4	2015-04-15 09:17:45.260616	2015-04-15 09:17:45.260616	OwnTyqX3TnV9Z-JJYNiPuA	\N	mp4	\N	not_convert	Lesson	\N	\N
164	2b80dafc91c434594cb384993e4e39e8.mp4	2015-04-15 10:15:54.599007	2015-04-15 10:15:54.599007	OwnTyqX3TnV9Z-JJYNiPuA	\N	mp4	\N	not_convert	Lesson	\N	\N
165	04f73750c9bb5774436ba0927c36b385.mp4	2015-04-15 10:22:29.117088	2015-04-15 10:22:29.117088	GzdW4kmi2mYtCRh1IcxREA	\N	mp4	\N	not_convert	Lesson	\N	\N
166	8c6113ae8a52e896b92921f72d0b6977.mp4	2015-04-15 10:23:23.46841	2015-04-15 10:23:23.46841	ypWxObuKZ_IBDvJ3fTERLQ	\N	mp4	\N	not_convert	Lesson	\N	\N
167	4bb873b59d5f34607e7d31d73d395766.mp4	2015-04-15 10:26:56.789507	2015-04-15 10:26:56.789507	G6gmb9-gF8eQMtaWmLed_Q	\N	mp4	\N	not_convert	Lesson	\N	\N
169	2955753b9d2794feda707a3d0ddc21fc.mp4	2015-04-18 02:45:25.500457	2015-04-18 02:45:25.500457	NmuHkKOl6v35e8f2efRkMw	\N	mp4	\N	not_convert	Lesson	\N	\N
170	45f61cfd9e6388ed848b43b108c611b2.mp4	2015-04-18 02:46:05.874909	2015-04-18 02:46:05.874909	kAxql4-C8Y62Znn4A_508w	\N	mp4	\N	not_convert	Lesson	\N	\N
171	19d0965a08bb214016765cf366cab305.mp4	2015-04-18 02:47:10.284419	2015-04-18 02:47:10.284419	bB86YGcUrCMdG_S634j4xA	\N	mp4	\N	not_convert	Lesson	\N	\N
172	dd063ed1121a28a6297c703970eee71b.mp4	2015-04-18 02:52:11.266814	2015-04-18 02:52:11.266814	LYr8hyeJKxkH4zMfehIYbw	\N	mp4	\N	not_convert	Lesson	\N	\N
173	a17ec3bcf20f19a229f0a3468db3c557.mp4	2015-04-18 02:53:16.912639	2015-04-18 02:53:16.912639	IFCmu1iCg50qbCDL25GvPA	\N	mp4	\N	not_convert	Lesson	\N	\N
174	ecadec53998524dfbf11d1b454c1f798.mp4	2015-04-18 02:54:54.879044	2015-04-18 02:54:54.879044	onFiu4UZqvmr_5LoHGhlPw	\N	mp4	\N	not_convert	Lesson	\N	\N
175	8d24eb32185e8161341aa82b7f68f6e0.mp4	2015-04-18 02:55:34.156335	2015-04-18 02:55:34.156335	EyStRNfhZRyCstsSDaHh8g	\N	mp4	\N	not_convert	Lesson	\N	\N
176	dcc93e045ec3c73f789dbb7c10d9b1cb.mp4	2015-04-18 02:56:22.964643	2015-04-18 02:56:22.964643	UJ7YY2uHl6gU3T9UTBeVWg	\N	mp4	\N	not_convert	Lesson	\N	\N
177	5d86563f957f8b02958de235185c650f.mp4	2015-04-18 02:57:38.782891	2015-04-18 02:57:38.782891	CVdnitXj_TLEbFJURbAimw	\N	mp4	\N	not_convert	Lesson	\N	\N
178	bcd3327e9bfa9ae1b04249905b940339.mp4	2015-04-18 03:00:15.04276	2015-04-18 03:00:15.04276	dYoZGMI-kiG4Uny8XbZTCQ	\N	mp4	\N	not_convert	Lesson	\N	\N
179	859bae53bc75215c68ff4b27819dc1e6.mp4	2015-04-18 03:01:14.601649	2015-04-18 03:01:14.601649	QtDT6JusCtnjXCVklv7Ltg	\N	mp4	\N	not_convert	Lesson	\N	\N
180	e39d964fdf2fc2f8f2fa182d2b1be9de.mp4	2015-04-18 22:26:48.397246	2015-04-18 22:26:48.397246	Poa8QsAv0rHN5Au47_VP5w	\N	mp4	\N	not_convert	Lesson	\N	\N
181	636dc59147fc5a5ed5024aab94f651f5.mp4	2015-04-18 22:27:11.072239	2015-04-18 22:27:11.072239	8hzrpj4-SNID130pSxZQVA	\N	mp4	\N	not_convert	Lesson	\N	\N
182	e9a62f65e3d5e413358c9d413df71573.mp4	2015-04-18 22:27:58.809753	2015-04-18 22:27:58.809753	NVa6zqSrcVz_QDpUmLhJzA	\N	mp4	\N	not_convert	Lesson	\N	\N
184	6798ad76a46cc221e32003ea0de91a57.mp4	2015-04-22 23:19:53.33729	2015-04-22 23:19:53.33729	4C4THzVhdvf0567kCcw89g	\N	mp4	\N	not_convert	Lesson	\N	\N
188	c88974bf0242456fd3081d758f48e469.mp4	2015-04-27 23:03:41.952816	2015-04-27 23:03:41.952816	khzzNJ8GtBOsKzZ9nUibHw	\N	mp4	\N	not_convert	Lesson	\N	\N
192	e48a41f0aee29e126ce8c0d2a9ad3c6c.mp4	2015-04-28 22:48:31.074938	2015-04-28 22:48:31.074938	fuI9ahYSX-RxWgltcYlasg	\N	mp4	\N	not_convert	Lesson	\N	\N
193	bb68e328d2fc0b9e776e58e8f90b5d92.mp4	2015-04-28 22:50:17.530062	2015-04-28 22:50:17.530062	wq_TyMA6I34V12JUkDrBGA	\N	mp4	\N	not_convert	Lesson	\N	\N
202	fe24f46d7c685657967b5c7d8df50af5.mp4	2015-04-29 11:36:39.377654	2015-04-29 11:36:43.702946	FKT3FyISkC6Bk-wuK28Yxw	\N	mp4	\N	not_convert	Lesson	\N	\N
204	4069a03d3d673a8554ddc3668290686f.mp4	2015-04-29 13:16:27.801333	2015-04-29 13:19:02.949782	jV-bxKzCyWn2Sf7X3jPdUA	\N	mp4	\N	not_convert	Lesson	\N	\N
209	106ba5b7781a27f908c8ef672fd87822.mp4	2015-04-29 21:40:49.083886	2015-04-29 21:40:57.902895	9E3um9lbfIA0Gs8Fhq3b2A	\N	mp4	\N	not_convert	Lesson	\N	\N
263	838aac2bcbad464e687191d07d9cc729.mp4	2015-04-30 22:49:57.308711	2015-04-30 22:49:58.482068	wx7ESkzfin7fvSC9cGTBZA	\N	mp4	\N	not_convert	Lesson	\N	\N
262	5334d58efc888ad659cad6b3a2d5c18a.mp4	2015-04-30 22:43:19.258302	2015-04-30 22:43:20.183375	SsdYsz2ljnOrzMVpOB4WMg	\N	mp4	\N	not_convert	Lesson	\N	\N
265	eb244f13d5dd3416d408fc3800cdd12c.mp4	2015-04-30 22:52:53.221387	2015-04-30 22:52:54.442898	0Oe6BhL5hGemtSeVxaYxww	\N	mp4	\N	not_convert	Lesson	\N	\N
266	62eadfba3e4c1e495b8394030e655b66.mp4	2015-04-30 22:57:09.890436	2015-04-30 22:57:11.101009	qxawzyR0hKeRyNRgAtK5CQ	\N	mp4	\N	not_convert	Lesson	\N	\N
267	e1f0a924643c48a67176e4a619835bb3.mp4	2015-04-30 22:57:58.51169	2015-04-30 22:57:59.694815	ubslurTidvnVI_BrEkVwjg	\N	mp4	\N	not_convert	Lesson	\N	\N
268	19cf67e25969a3a1d6011d9c1c4bacef.mp4	2015-04-30 22:58:41.43322	2015-04-30 22:58:42.72539	_dtxaTMeIEhwQ8uHZcGr9w	\N	mp4	\N	not_convert	Lesson	\N	\N
269	7f3e3b9f35e57e7e2412492141bb6270.mp4	2015-04-30 22:59:28.412505	2015-04-30 22:59:29.607215	PWQQpHWozOSAD0iD6a2aHQ	\N	mp4	\N	not_convert	Lesson	\N	\N
270	831d9281508d3b44066c244a0d924ade.mp4	2015-04-30 23:04:51.162902	2015-04-30 23:04:52.274703	YlEijITQ2vmBgep7H6l2mw	\N	mp4	\N	not_convert	Lesson	\N	\N
271	ca7695f3cb430d8771d6769162c45869.mp4	2015-04-30 23:06:06.82256	2015-04-30 23:06:08.191356	7pVRJXfoqf-gOzVK85I1ZQ	\N	mp4	\N	not_convert	Lesson	\N	\N
272	aaf2fe8b373b2c16d6d7dac51f105736.mp4	2015-04-30 23:07:22.000916	2015-04-30 23:07:23.226848	xYZBaD1KyRmjo_ufeieU-w	\N	mp4	\N	not_convert	Lesson	\N	\N
280	db13baa03795508ad2cfb768dcda1d06.mp4	2015-06-02 22:19:08.286017	2015-06-02 22:19:08.883788	rQls-zT4MHjNfppmMK0Hcw	\N	mp4	\N	in_queue	Lesson	\N	\N
281	9423c8b2216ae8f57f25858136b1dc22.mp4	2015-06-02 22:26:55.739915	2015-06-02 22:26:56.366994	Y4BGceKBpKpRw3d2KbW4CA	\N	mp4	\N	in_queue	Lesson	\N	\N
6	\N	2014-06-27 07:31:40.839996	2015-08-24 07:40:14.214607	PiWSwKV6H7RHuLzxGupyEw	6	mp4	\N	not_convert	Lesson	2	\N
97	96e2742453167d12bce061dd972b5b84.mp4	2015-02-14 15:43:16.736086	2015-08-24 07:40:13.872413	OSdJwYayBtFbgO5xCB1eCQ	53	mp4	\N	not_convert	Lesson	7	\N
98	5acae4dd5b98ee2b0b37527c975694e9.mp4	2015-02-21 10:02:35.374537	2015-08-24 07:40:13.884703	E1UIV6cu_wP1UNBz0jCF3Q	54	mp4	\N	not_convert	Lesson	7	\N
99	dfd05af32bb05a7e485d269e1a557527.mp4	2015-02-27 14:00:19.390609	2015-08-24 07:40:13.900814	DHCtRC6N0ekIeq8cwn892w	55	mp4	\N	not_convert	Lesson	7	\N
100	4396274cd7da15955eb995cef2be6fe7.mp4	2015-03-05 09:25:31.077422	2015-08-24 07:40:13.911764	D1w8eQPaEKY8jtRKxZb_OQ	56	mp4	\N	not_convert	Lesson	7	\N
115	c260e074a1579dd01839b8ed57c95761.mp4	2015-03-23 04:15:18.189009	2015-08-24 07:40:13.922588	sf4STXJ7pQqiPZpujlFnAQ	70	mp4	\N	not_convert	Lesson	26	\N
103	6b7077fc6d8229172095cd45595b1b8e.mp4	2015-03-11 16:29:54.869626	2015-08-24 07:40:13.933229	NfbwXVgmA3S3J6IFNay-5g	58	mp4	\N	not_convert	Lesson	7	\N
104	6184dd30e2fcb83e31dbae15bd7fb11b.mp4	2015-03-18 14:03:07.625049	2015-08-24 07:40:13.946144	u-sbj4_nMmMbNejOT7T8Fw	59	mp4	\N	not_convert	Lesson	26	\N
105	14c064b1068ea8519f0cc9597c38ff65.mp4	2015-03-21 12:19:02.311391	2015-08-24 07:40:13.955883	RDcFUi9TsRLb8gY3Ze9Quw	60	mp4	\N	not_convert	Lesson	26	\N
106	6fa9eb943097054609caee3cb77f626b.mp4	2015-03-21 12:21:38.394107	2015-08-24 07:40:13.967796	_bdRg-Tyxwo6sT_wA9DSbQ	61	mp4	\N	not_convert	Lesson	26	\N
107	94c31d01b6433011223b636c5bd66025.mp4	2015-03-21 12:23:18.429404	2015-08-24 07:40:13.982387	weuqq9Zlcl0hQ7yleOYFiw	62	mp4	\N	not_convert	Lesson	26	\N
108	7f17cd8522203d09e0f64d36cd53b47a.mp4	2015-03-21 12:25:02.129058	2015-08-24 07:40:13.993747	TG21lgreKQueiHTV6OYRNQ	63	mp4	\N	not_convert	Lesson	26	\N
109	a0a4a0346526850ea04a7b21b3128892.mp4	2015-03-21 12:26:28.10771	2015-08-24 07:40:14.002807	KYG1F-4rX70KUCJk-dtrAQ	64	mp4	\N	not_convert	Lesson	26	\N
110	14eec002fde44bc0f7ed6363644e6423.mp4	2015-03-21 12:40:05.646719	2015-08-24 07:40:14.01408	WVsbJfMtDxW0NCfA4kXedA	65	mp4	\N	not_convert	Lesson	26	\N
111	9279f4d4a2bd12d92ce5fd3f3fd9b3b0.mp4	2015-03-21 12:41:44.391958	2015-08-24 07:40:14.024046	UmxglqMN13nSpE3cy9-LPQ	66	mp4	\N	not_convert	Lesson	26	\N
112	ca2b577cce6fc1a8ca84fac8ed87996d.mp4	2015-03-22 14:24:13.500461	2015-08-24 07:40:14.035785	EZggawSmqmyupWuQuLBuhQ	67	mp4	\N	not_convert	Lesson	24	\N
113	8d2f2a5a8f8f98a5de8d89e3ca306b12.mp4	2015-03-22 14:53:40.118028	2015-08-24 07:40:14.048669	GikGi9VTS017vmj1__k-zA	68	mp4	\N	not_convert	Lesson	7	\N
116	34a8c1198cbc50d7719c5c5e83eb3e48.mp4	2015-03-23 04:16:39.141944	2015-08-24 07:40:14.060082	eW_HRIorXvlKsJOXdmAYEg	71	mp4	\N	not_convert	Lesson	26	\N
117	2ba2db4e6a9fe6f4fa036740e77f3445.mp4	2015-03-23 04:29:19.670137	2015-08-24 07:40:14.070966	VPXSSQO7rAYm6YWgDoFRug	72	mp4	\N	not_convert	Lesson	26	\N
3	249c879ebcb7c4d09104944e06e00322.mp4	2014-06-27 07:09:34.497763	2015-08-24 07:40:14.176903	HfoWLacqf0oidU079s5WTg	3	mp4	\N	not_convert	Lesson	2	\N
4	4df518b2f39446be68c4dd4232f7ae6c.mp4	2014-06-27 07:10:30.312925	2015-08-24 07:40:14.193027	vYqLl7EvAxYHPS-WRINIRg	4	mp4	\N	not_convert	Lesson	2	\N
5	393f8d63720e7687500b491b4e83999e.mp4	2014-06-27 07:31:00.366694	2015-08-24 07:40:14.20498	ArbdaKgiD38PHGU2vIunQg	5	mp4	\N	not_convert	Lesson	2	\N
7	6e4ec170db549d6da65e48699e511c0e.mp4	2014-06-27 07:42:11.023895	2015-08-24 07:40:14.224963	3srhRnDyBv4WhJDJaSEm4A	7	mp4	\N	not_convert	Lesson	2	\N
8	4e33ffc40f7010f474949cb3f1265f56.mp4	2014-06-27 08:28:45.55769	2015-08-24 07:40:14.235089	mUHjL1X2JsMMXS6QHl0Chg	8	mp4	\N	not_convert	Lesson	2	\N
9	eacf24b27a84891319916d9a678845ba.mp4	2014-06-27 08:31:33.690048	2015-08-24 07:40:14.247884	0zfI05DEVus6yN6jERUVYg	9	mp4	\N	not_convert	Lesson	2	\N
10	406cdb39f47d68b78d66747b184e6425.mp4	2014-06-27 08:41:30.679291	2015-08-24 07:40:14.258324	DCH58BwFePS1BuTddYLauA	10	mp4	\N	not_convert	Lesson	2	\N
11	9ecc479da8bdeb5b2c3289d64cb55f26.mp4	2014-06-27 10:07:08.144117	2015-08-24 07:40:14.272675	-pgjzNhZUqq2lP5c1-Cbjg	11	mp4	\N	not_convert	Lesson	2	\N
12	c81e020c77b0b3725456af9c34384b59.mp4	2014-06-27 10:08:08.682744	2015-08-24 07:40:14.286448	HnJsPDhze0Qbt-9QfBP-Rg	12	mp4	\N	not_convert	Lesson	2	\N
13	09465d9bb1b3faa5dd23002c97a41763.mp4	2014-06-28 00:53:59.158063	2015-08-24 07:40:14.29598	H4JbAYwlY3rCG_4UFt94ZA	13	mp4	\N	not_convert	Lesson	2	\N
16	c61ea84cc452dd627acd21bf95b16bcc.mp4	2014-06-28 07:22:09.65792	2015-08-24 07:40:14.306281	dJ-kY8gUdH3eDXWaMPJX8w	14	mp4	\N	not_convert	Lesson	2	\N
30	\N	2014-09-29 08:47:08.695192	2015-08-24 07:40:14.31753	wNDVy4c-pkw29ilvfMZ4OA	20	mp4	\N	not_convert	Lesson	20	\N
31	ef1f7a693f03e6805b535c58ea24e16f.mp4	2014-09-30 04:09:23.399981	2015-08-24 07:40:14.328895	WLgS7nc9BcMR1gLxkOx_iw	21	mp4	\N	not_convert	Lesson	7	\N
36	2fac0b600978a73a39a0af8cc870ce62.mp4	2014-10-19 05:20:26.059497	2015-08-24 07:40:14.339944	JjpJDwSBnQTAYCOM9ViRCg	22	mp4	\N	not_convert	Lesson	7	\N
38	9a06e87fe77530b55b15f7bbaadb08da.mp4	2014-10-22 12:02:41.035064	2015-08-24 07:40:14.351669	QGUKCutr6VDfyfdbbm7XEQ	23	mp4	\N	not_convert	Lesson	26	\N
143	f9016acb1f1b5d4d6e2a534ac4990972.mp4	2015-04-13 13:54:48.388338	2015-08-24 07:40:14.363993	A8HEtrsa7vZmd_e8vHgDcg	94	mp4	\N	not_convert	Lesson	7	\N
168	16bc7372c96dd4ed14ae260ff46a1c94.mp4	2015-04-15 10:28:13.485657	2015-08-24 07:40:14.374296	VpytTdUcNPjt_2fF__MSbw	95	mp4	\N	not_convert	Lesson	65	\N
185	a5ed99aded013fff6d732a16628c7345.mp4	2015-04-22 23:22:14.168237	2015-08-24 07:40:14.389032	4C4THzVhdvf0567kCcw89g	97	mp4	\N	not_convert	Lesson	2	\N
187	49d111db6e35bd8e290139068493cb72.mp4	2015-04-27 23:00:48.782836	2015-08-24 07:40:14.403456	8l480XYMBvHNFLlXWWPRYw	99	mp4	\N	not_convert	Lesson	2	\N
190	3c568cce7b41bed23ac2a8aedfb2ab0f.mp4	2015-04-28 22:05:32.076963	2015-08-24 07:40:14.413637	0i2S7ZeHbXj-fopCMe3QCw	100	mp4	\N	not_convert	Lesson	2	\N
210	352a9256cf942609bba52f509bb70f88.mp4	2015-04-29 21:58:29.639972	2015-08-24 07:40:14.423442	rGpfMhTr0s6-L22GU2bimA	114	mp4	\N	not_convert	Lesson	2	\N
212	2b7fce422d4342af5096a1e2a966e2cd.mp4	2015-04-29 22:01:32.509135	2015-08-24 07:40:14.434505	3H6qEZIlp98KyIxEHA56gw	115	mp4	\N	not_convert	Lesson	2	\N
213	718e93c663c13e246bfeca90234a810b.mp4	2015-04-29 22:04:04.386875	2015-08-24 07:40:14.459027	wvjbiyVtfNFiTW44U1JxUA	116	mp4	\N	not_convert	Lesson	2	\N
251	\N	2015-04-30 03:55:16.440357	2015-08-24 07:40:14.470481	vRZ80KpafxuSb1vtN9GV6Q	154	mp4	\N	not_convert	Lesson	2	\N
249	3ebd68079c7f8d66620463274fc41dd4.mp4	2015-04-30 02:22:28.838184	2015-08-24 07:40:14.483718	gSrT95oBhZpt3jwN7vCHJg	152	mp4	\N	not_convert	Lesson	2	\N
250	fb56f72492bff712412f1a9de22636c7.mp4	2015-04-30 02:27:17.286619	2015-08-24 07:40:14.494187	BFIK8-XjY-_gWqjDthqeXQ	153	mp4	\N	not_convert	Lesson	2	\N
274	6e4facd51502956e2a30245799417656.mp4	2015-05-02 06:10:52.136458	2015-08-24 07:40:14.510764	6SPFQGL_FWFWdoW77CPygQ	157	mp4	\N	not_convert	Lesson	2	\N
273	32a87c00a37abbd289b168a277234d57.mp4	2015-05-02 05:55:19.504406	2015-08-24 07:40:14.523097	vlHF_OAcNxG_afkwPr7jSQ	156	mp4	\N	not_convert	Lesson	2	\N
275	13843fe432b06c6769a589c2808feff4.mp4	2015-05-02 08:54:18.198175	2015-08-24 07:40:14.53328	VpwDVmvMOFh9Dq2rDd1jIg	158	mp4	f94f270368e39584f6a3c1e4d85c95fe.mp4	convert_success	Lesson	2	\N
278	\N	2015-05-31 00:09:07.671211	2015-08-24 07:40:14.557058	gFlR2FC7rEHdKLwcM03r4g	161	mp4	\N	not_convert	Lesson	2	\N
279	\N	2015-06-01 22:25:09.951471	2015-08-24 07:40:14.567425	H6Nu6Dszxbq9qvYpCl8vXw	162	mp4	\N	not_convert	Lesson	2	\N
45	2fefb93c37ab5e7a6d805ec2bc1705c8.mp4	2014-10-23 14:31:40.517712	2015-08-24 07:40:14.579771	FmM2GboB1cTRE1IelS0cJA	25	mp4	\N	not_convert	Lesson	26	\N
50	e7b1f54481f19126cff5f9d189ee1136.mp4	2014-10-31 09:20:26.687606	2015-08-24 07:40:14.590716	vUjP-OXhk6LrR6B5PnTx_g	28	mp4	\N	not_convert	Lesson	20	\N
60	113cc229175218c975964340e11c1af7.mp4	2014-11-03 00:15:24.284499	2015-08-24 07:40:14.602583	cfwWp79J2qV4NJBJzk9yvw	31	mp4	\N	not_convert	Lesson	30	\N
62	375b29889e5cdbac8447060c2a2a26b0.mp4	2014-11-03 07:22:29.09222	2015-08-24 07:40:14.617141	T2I60OnEp2S7CFUKrrYYDg	32	mp4	\N	not_convert	Lesson	7	\N
67	29c83754b4519cb741e9e9770b8f13e0.mp4	2014-11-06 08:02:06.977562	2015-08-24 07:40:14.645298	kumYjQhXYt2LTcd0WTpJiA	33	mp4	\N	not_convert	Lesson	7	\N
69	28dbe97959f1112fad6ea08bfae459d5.mp4	2014-11-10 09:28:45.877173	2015-08-24 07:40:14.655711	M_-thDQ52zOEuGgGcEA4hg	34	mp4	\N	not_convert	Lesson	33	\N
70	22bcc3c3484d712c42218177378da128.mp4	2014-11-10 15:12:27.048593	2015-08-24 07:40:14.667194	okjUQX4AIhQF1OkLKiMKYQ	35	mp4	\N	not_convert	Lesson	7	\N
71	9d4ee69c029132e6e65a410852f8a4cd.mp4	2014-11-11 12:56:43.065419	2015-08-24 07:40:14.678477	tp0vhU-enUfD8PUlDlnmMg	36	mp4	\N	not_convert	Lesson	26	\N
72	9c80a5e87da63d5199757c29160f7ff8.mp4	2014-11-11 13:00:49.345968	2015-08-24 07:40:14.688595	HEbPwvIMLJ1WiUycS67OvQ	37	mp4	\N	not_convert	Lesson	26	\N
73	e1c46d925b2210f86b647e8b51ea91ca.mp4	2014-11-11 13:02:30.604068	2015-08-24 07:40:14.701546	Gx987aX_i12dWUShnQtlXQ	38	mp4	\N	not_convert	Lesson	26	\N
74	4805e1d65eff4e3b01993f5be85ad0b4.mp4	2014-11-13 04:24:48.382206	2015-08-24 07:40:14.71149	-ihUjHu0XONeaHXWqsP6OA	39	mp4	\N	not_convert	Lesson	33	\N
76	99f69ace5d34daa72d41df371f1a198b.mp4	2014-11-13 04:42:44.601305	2015-08-24 07:40:14.728558	dtEpbLL5BFRQfIeTfZuvZA	40	mp4	\N	not_convert	Lesson	33	\N
84	b7671651cb294fff0d4e222829cfc5db.mp4	2014-11-18 11:23:34.038736	2015-08-24 07:40:14.740973	xKB91D7e13uKW8xwLtzGSw	41	mp4	\N	not_convert	Lesson	7	\N
86	ba866f7f8913fadffd7be742468f39ea.mp4	2014-11-29 14:09:05.617815	2015-08-24 07:40:14.753172	b185eeMMCbR3q6vgdjstZg	43	mp4	\N	not_convert	Lesson	7	\N
87	f8be9b348b343a57d5fb7e985128c357.mp4	2014-12-14 23:54:16.87399	2015-08-24 07:40:14.763184	2yibAhmFWiNv6xQnGYY9yQ	44	mp4	\N	not_convert	Lesson	33	\N
88	a390b91423ed830cb8ec87c94da6e9af.mp4	2014-12-15 00:14:22.92886	2015-08-24 07:40:14.773684	jhhm5Xh1tHE5ny9WI-ttkA	45	mp4	\N	not_convert	Lesson	33	\N
118	c7e6794be5950fb9ad6c1002b2996804.mp4	2015-03-23 04:31:10.239433	2015-08-24 07:40:14.786779	Z1s1xAPDxd33X_8uAhUPeg	73	mp4	\N	not_convert	Lesson	26	\N
119	5b82b585cfc325641fcacbcbad02c7bc.mp4	2015-03-23 04:32:50.324634	2015-08-24 07:40:14.796757	wcVjWbsok4cx-9h3nh6-6w	74	mp4	\N	not_convert	Lesson	26	\N
121	f54994b5724e482d5c3278ce9865e6d8.mp4	2015-03-23 04:35:11.493706	2015-08-24 07:40:14.807356	jwbHNsIoOQX0MTApV6i8Uw	75	mp4	\N	not_convert	Lesson	26	\N
122	96bf7762025ef8f68170419a0aae9ceb.mp4	2015-03-23 04:36:39.333983	2015-08-24 07:40:14.817106	-0hhGfs0T6NaimeEGTogaQ	76	mp4	\N	not_convert	Lesson	26	\N
124	3f451a36172f5d3eb82ab9cca7bf794d.mp4	2015-03-24 05:22:45.220596	2015-08-24 07:40:14.827671	l_6WewDOPg-qgIUlHRcPGA	77	mp4	\N	not_convert	Lesson	7	\N
130	597fef233051797fc4903af0036bf2de.mp4	2015-03-29 14:59:12.365664	2015-08-24 07:40:14.85157	POjwfhaMk_QKkD9vJ5muCg	80	mp4	\N	not_convert	Lesson	7	\N
132	c7da31ae7777cb87228f3b873e240d10.mp4	2015-04-04 05:42:51.198942	2015-08-24 07:40:14.862085	FqRgt_iCtmPqmQaNXHNwow	83	mp4	\N	not_convert	Lesson	7	\N
134	65cfda3888bc00746f80e7c8ad65edd6.mp4	2015-04-06 10:16:40.227089	2015-08-24 07:40:14.878149	cE-mHNjb69obIlFAI7FBlw	85	mp4	\N	not_convert	Lesson	7	\N
136	4228563b461ba98b4332e46c52b23869.mp4	2015-04-12 02:33:39.521057	2015-08-24 07:40:14.892397	hDFRUSZ1GzKobcODcLi4rA	87	mp4	\N	not_convert	Lesson	59	\N
135	034fe6039bdcf31d8517956cc127f16f.mp4	2015-04-12 02:30:01.133726	2015-08-24 07:40:14.904097	kQhQVsidyYgy01047B83OQ	86	mp4	\N	not_convert	Lesson	59	\N
137	1f36f0a2c12f2d038351d981d3a30987.mp4	2015-04-12 02:38:59.388497	2015-08-24 07:40:14.914716	QtBsRwhIhj2G2CZsx0V3mQ	88	mp4	\N	not_convert	Lesson	59	\N
138	a4dbe82b293a881be7bf7bc4b064b0b6.mp4	2015-04-12 02:44:49.85201	2015-08-24 07:40:14.925099	E4g3ZliZFMUkWyrhbSYcCg	89	mp4	\N	not_convert	Lesson	59	\N
276	cd3c2ebc7f26b4d96eafee5503c2eb48.mp4	2015-05-29 14:58:07.967365	2015-09-09 08:24:55.794503	V5d_rZVG5bmgQA2GsaX9Mw	159	mp4	96af6de8298c3190fa70357339df7b13.mp4	convert_success	Lesson	2	\N
131	c5a714f69263cc8c65d02e5b95ad0be2.mp4	2015-04-03 15:03:26.254923	2015-09-18 08:57:46.293851	9WadxJT75gVWao0AH_hhuA	81	mp4	\N	not_convert	Lesson	7	\N
292	35781328a850b774477ec1b70947c4dd.mp4	2015-09-18 07:05:15.382369	2015-09-18 07:05:19.819066	1442559887-6sgZ1ej5pShMqNyII5QeDA	7	mp4	\N	in_queue	Correction	2	\N
293	f3f52c51d56d982005521e523304e54d.mp4	2015-09-18 07:25:35.448572	2015-09-18 07:25:48.545839	1442561022-bRqfnrBZygSi9Qwq2JbQeA	8	mp4	\N	in_queue	Correction	2	\N
291	8166d1106eec361bec01a67557e165d1.mp4	2015-09-18 07:04:39.420461	2015-09-18 07:04:47.185941	1442559866-WZwpNtk8P7O_lZWnApRLFg	6	mp4	\N	in_queue	Correction	2	\N
294	fd7b6c918e7b547e9bcbae84ef33f7bb.mp4	2015-09-18 07:32:37.817581	2015-09-18 07:32:44.799275	1442561148-NvhoyuxzJ3R_3_Whx7Y7ZQ	9	mp4	\N	in_queue	Correction	2	\N
300	fd47e6aa263c242a7253ca7da56db41d.mp4	2015-10-10 13:44:12.817728	2015-10-10 14:02:53.388058	1444484627-jwUgAHWOMD7OgtS_2JlpoQ	15	mp4	2535abb844165b3c70e465afcdd683b9.mp4	convert_success	CustomizedTutorial	76	728
302	cbc824de3a43cc1b2a1604b2f79a6cf9.mp4	2015-10-10 14:02:10.732842	2015-10-10 14:18:24.605936	1444485673-v5dzaqXtVL-Cozl7bBaUZA	16	mp4	58318087debc5e2e099f2d427846dcc8.mp4	convert_success	Correction	76	728
301	b78846fd22cd2379d976074b7a476e95.mp4	2015-10-10 13:46:44.170311	2015-10-10 14:09:25.180144	1444484767-0KejWLzhS_94rpriz9cHpQ	55	mp4	71893a0057ba7e6a327d3abcc38285ed.mp4	convert_success	Reply	76	728
297	63c58026ce2100bfe1ce99df46ae66c7.mp4	2015-09-28 22:54:54.582155	2015-10-10 13:26:27.482505	1443480883-83AJBEzLBDXBeD57djgKiA	12	mp4	\N	convert_fail	CustomizedTutorial	2	\N
298	d2dc7d1d9d3d85d2b5d976f89efd8583.mp4	2015-09-28 23:11:19.140016	2015-10-10 13:26:27.532757	1443481864-W_gKimHJ3tB9VKZT5NLAUg	13	mp4	\N	convert_fail	CustomizedTutorial	2	\N
295	f7d5a34b614a565987dd89eba035cb17.mp4	2015-09-26 01:00:56.723759	2015-10-10 13:26:27.628775	1443229207-0dHF-i7-S7UukrllFeHQ6g	2	mp4	\N	convert_fail	CustomizedTutorial	2	\N
296	e07680acf2d9a725f56f86f6af52570c.mp4	2015-09-28 22:50:23.585629	2015-10-10 13:26:27.640616	1443480596-uJoFiyTksdpkxM-kULD8dw	\N	mp4	\N	convert_fail	\N	57	\N
311	761ebe6661c0d9a63053528aa2ca02bf.mp4	2015-10-18 01:50:57.761847	2015-10-18 01:57:32.807272	1445133042-gnpvQKcnhiHsDlNoq5hoeg	72	mp4	4a6abeb8c11ee53a6dfcf48a70cd7b6c.mp4	convert_success	Reply	76	42
299	7290ee251b1bcb5c466558d4ef851608.mp4	2015-10-10 13:33:05.538124	2015-10-10 13:41:37.72201	1444483952-SqJcodpleza4VMgQqgPsPw	14	mp4	f99dd7974a716e1f4c3ff43ca1044e1e.mp4	convert_success	CustomizedTutorial	76	728
304	f86444525f91f84e7945f81af790dfa5.mp4	2015-10-11 09:02:04.73011	2015-10-18 01:00:40.522528	1444552234-VVwmnatHLS30m_McjPVXVg	58	mp4	\N	convert_fail	TutorialIssueReply	57	\N
306	6a04f94103946078235e2a827cdddd12.mp4	2015-10-11 12:58:01.800299	2015-10-18 01:00:41.498256	1444567911-MZWsChqU-jOh81yMevB5AQ	66	mp4	\N	convert_fail	TutorialIssueReply	57	\N
303	120d85dbf5060175e90d4619a9610a82.mp4	2015-10-11 08:31:04.698626	2015-10-18 01:00:41.81902	1444552234-VVwmnatHLS30m_McjPVXVg	58	mp4	\N	convert_fail	TutorialIssueReply	57	\N
305	fb3d42855ab96cd82c533a34683e23e0.mp4	2015-10-11 12:51:20.887747	2015-10-18 01:00:41.877766	1444567851-bJKDKPQypML993v_nTaHtA	65	mp4	\N	convert_fail	TutorialIssueReply	57	\N
307	032e1d183a3d9a11388bf74bcbf3bf41.mp4	2015-10-11 13:40:15.471744	2015-10-11 13:40:31.301278	1444568311-ClHMTEbKd-ZyGgSEDA1Wpw	69	mp4	\N	in_queue	Reply	57	\N
308	54e9b37a4d25cc03610f980436d3398b.mp4	2015-10-11 13:41:38.879297	2015-10-11 13:42:00.80214	1444568311-ClHMTEbKd-ZyGgSEDA1Wpw	69	mp4	\N	in_queue	Reply	57	\N
309	7922a8c5020444c8f63bcf456ef07544.mp4	2015-10-11 13:42:52.586366	2015-10-11 13:43:07.256095	1444570943-C8COxlKve4URoHmx8TP0zw	70	mp4	\N	in_queue	Reply	57	\N
310	740c00a071af0d9cf1d9df67845b0370.mp4	2015-10-18 01:05:06.731437	2015-10-18 01:13:41.26603	1445130122-gIMG37y361f9_Jwqts2C4w	71	mp4	6d437282e63b294de6b2d5bd9d448828.mp4	convert_success	Reply	76	42
312	233b46312de4e8333bc547a6b57c5a54.mp4	2015-10-22 22:17:44.52593	2015-10-25 00:06:59.276425	1445552234-7zw_gaDdDduuWmJsggWVnA	\N	mp4	\N	convert_fail	\N	76	\N
314	dddf268ea6edcb41d3ed2276557f92ad.mp4	2015-10-22 23:00:10.435785	2015-10-25 00:06:59.287096	1445554432-XrSYpm2JFwvIMQlGhomtuQ	\N	mp4	\N	convert_fail	\N	76	\N
313	800bfc3a30a678058ffe39a859f123dc.mp4	2015-10-22 22:52:57.700579	2015-10-25 00:06:59.293645	1445554347-YXOdd9SRmd9PSBUxVPmtGw	19	mp4	\N	convert_fail	Correction	76	\N
315	eb50028fcd439629c79daa8db2fbe290.mp4	2015-10-23 07:53:50.344521	2015-10-25 00:06:59.301831	1445586815-V2LRQr48h6zzgtuijKbGQA	22	mp4	\N	convert_fail	Correction	76	\N
318	47fada0197cf07222dd4576507b1f025.mp4	2015-10-25 01:44:58.969669	2015-10-25 01:48:24.031207	1445737476-fjhDwD0WjHr4djHfo2z2_Q	31	mp4	e9c30e7d4a0e55e4e1695e4269cdaace.mp4	convert_success	Correction	76	42
316	8c613173308bc71d835517551dd8d31e.mp4	2015-10-23 08:22:42.735773	2015-10-23 08:22:47.866	1445588551-ql6ea-2uljQDSCf2r4hDBA	28	mp4	\N	in_queue	Correction	76	\N
317	bc4b7d24b8ecf6d4c16f352c91cab3ed.mp4	2015-10-25 00:10:12.417539	2015-10-25 00:13:28.597702	1445731798-9gPdlRu84xeQZ3VMiaoc9Q	30	mp4	8f53f28849f520b2bbfecd8f43a8be6f.mp4	convert_success	Correction	76	42
\.


--
-- Name: videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('videos_id_seq', 318, true);


--
-- Data for Name: vip_classes; Type: TABLE DATA; Schema: public; Owner: qatime
--

COPY vip_classes (id, subject, category, questions_count, created_at, updated_at) FROM stdin;
4	生物	高中	\N	2015-04-09 23:07:20.247691	2015-04-09 23:07:20.247691
3	化学	高中	\N	2015-04-09 23:07:20.253641	2015-04-09 23:07:20.253641
5	数学	初中	\N	2015-04-09 23:07:20.259694	2015-04-09 23:07:20.259694
8	生物	初中	\N	2015-04-09 23:07:20.271033	2015-04-09 23:07:20.271033
7	化学	初中	\N	2015-04-09 23:07:20.276846	2015-04-09 23:07:20.276846
6	物理	初中	0	2015-04-09 23:07:20.26531	2015-04-09 23:07:20.26531
9	英语	高中	\N	2015-05-09 11:27:24.723366	2015-05-09 11:27:24.723366
1	数学	高中	0	2015-04-09 23:07:20.234518	2015-04-09 23:07:20.234518
2	物理	高中	4	2015-04-09 23:07:20.241306	2015-04-09 23:07:20.241306
\.


--
-- Name: vip_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: qatime
--

SELECT pg_catalog.setval('vip_classes_id_seq', 9, false);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: answers_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: cash_operation_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY cash_operation_records
    ADD CONSTRAINT cash_operation_records_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: consumption_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY consumption_records
    ADD CONSTRAINT consumption_records_pkey PRIMARY KEY (id);


--
-- Name: corrections_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY corrections
    ADD CONSTRAINT corrections_pkey PRIMARY KEY (id);


--
-- Name: course_purchase_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY course_purchase_records
    ADD CONSTRAINT course_purchase_records_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: curriculums_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY curriculums
    ADD CONSTRAINT curriculums_pkey PRIMARY KEY (id);


--
-- Name: customized_course_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY customized_course_assignments
    ADD CONSTRAINT customized_course_assignments_pkey PRIMARY KEY (id);


--
-- Name: customized_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY customized_courses
    ADD CONSTRAINT customized_courses_pkey PRIMARY KEY (id);


--
-- Name: customized_tutorials_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY customized_tutorials
    ADD CONSTRAINT customized_tutorials_pkey PRIMARY KEY (id);


--
-- Name: earning_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY earning_records
    ADD CONSTRAINT earning_records_pkey PRIMARY KEY (id);


--
-- Name: examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (id);


--
-- Name: excercises_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY excercises
    ADD CONSTRAINT excercises_pkey PRIMARY KEY (id);


--
-- Name: exercises_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);


--
-- Name: faq_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY faq_topics
    ADD CONSTRAINT faq_topics_pkey PRIMARY KEY (id);


--
-- Name: faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: fees_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY fees
    ADD CONSTRAINT fees_pkey PRIMARY KEY (id);


--
-- Name: learning_plan_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY learning_plan_assignments
    ADD CONSTRAINT learning_plan_assignments_pkey PRIMARY KEY (id);


--
-- Name: learning_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY learning_plans
    ADD CONSTRAINT learning_plans_pkey PRIMARY KEY (id);


--
-- Name: lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: qa_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY qa_faqs
    ADD CONSTRAINT qa_faqs_pkey PRIMARY KEY (id);


--
-- Name: qa_files_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY qa_files
    ADD CONSTRAINT qa_files_pkey PRIMARY KEY (id);


--
-- Name: question_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY question_assignments
    ADD CONSTRAINT question_assignments_pkey PRIMARY KEY (id);


--
-- Name: questions_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: recharge_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY recharge_codes
    ADD CONSTRAINT recharge_codes_pkey PRIMARY KEY (id);


--
-- Name: recharge_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY recharge_records
    ADD CONSTRAINT recharge_records_pkey PRIMARY KEY (id);


--
-- Name: register_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY register_codes
    ADD CONSTRAINT register_codes_pkey PRIMARY KEY (id);


--
-- Name: replies_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY replies
    ADD CONSTRAINT replies_pkey PRIMARY KEY (id);


--
-- Name: review_records_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY review_records
    ADD CONSTRAINT review_records_pkey PRIMARY KEY (id);


--
-- Name: schools_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: searches_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: solutions_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY solutions
    ADD CONSTRAINT solutions_pkey PRIMARY KEY (id);


--
-- Name: student_id_course_id; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY course_purchase_records
    ADD CONSTRAINT student_id_course_id UNIQUE (student_id, course_id);


--
-- Name: teaching_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY teaching_programs
    ADD CONSTRAINT teaching_programs_pkey PRIMARY KEY (id);


--
-- Name: teaching_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY teaching_videos
    ADD CONSTRAINT teaching_videos_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: videos_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (id);


--
-- Name: vip_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: qatime; Tablespace: 
--

ALTER TABLE ONLY vip_classes
    ADD CONSTRAINT vip_classes_pkey PRIMARY KEY (id);


--
-- Name: index_course_purchase_records_on_course_id; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_course_purchase_records_on_course_id ON course_purchase_records USING btree (course_id);


--
-- Name: index_course_purchase_records_on_student_id; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_course_purchase_records_on_student_id ON course_purchase_records USING btree (student_id);


--
-- Name: index_faqs_on_user_id; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_faqs_on_user_id ON faqs USING btree (user_id);


--
-- Name: index_lessons_on_tags; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_lessons_on_tags ON lessons USING gin (tags);


--
-- Name: index_nodes_on_name; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_nodes_on_name ON nodes USING btree (name);


--
-- Name: index_questions_on_answers_info; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_questions_on_answers_info ON questions USING gin (answers_info);


--
-- Name: index_questions_on_last_answer_info; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_questions_on_last_answer_info ON questions USING gin (last_answer_info);


--
-- Name: index_recharge_codes_on_code; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_recharge_codes_on_code ON recharge_codes USING btree (code);


--
-- Name: index_teaching_videos_on_token; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_teaching_videos_on_token ON teaching_videos USING btree (token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_remember_token; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_users_on_remember_token ON users USING btree (remember_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_videos_on_token; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE INDEX index_videos_on_token ON videos USING btree (token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: unique_teacher; Type: INDEX; Schema: public; Owner: qatime; Tablespace: 
--

CREATE UNIQUE INDEX unique_teacher ON learning_plan_assignments USING btree (learning_plan_id, teacher_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--


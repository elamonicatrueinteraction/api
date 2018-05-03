--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    institution_id uuid,
    gps_coordinates geography(Point,4326),
    street_1 character varying,
    street_2 character varying,
    zip_code character varying,
    city character varying,
    state character varying,
    country character varying,
    contact_name character varying,
    contact_cellphone character varying,
    contact_email character varying,
    telephone character varying,
    open_hours character varying,
    notes character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lookup character varying,
    gateway character varying,
    gateway_id character varying,
    gateway_data jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE addresses OWNER TO olgalover;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO olgalover;

--
-- Name: bank_accounts; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE bank_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bank_name character varying,
    number character varying,
    type character varying,
    cbu character varying,
    shipper_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE bank_accounts OWNER TO olgalover;

--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE deliveries (
    id bigint NOT NULL,
    order_id uuid,
    trip_id uuid,
    amount numeric(12,4) DEFAULT 0,
    bonified_amount numeric(12,4) DEFAULT 0,
    origin_id uuid,
    origin_gps_coordinates geography(Point,4326),
    destination_id uuid,
    destination_gps_coordinates geography(Point,4326),
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    gateway character varying,
    gateway_id character varying,
    gateway_data jsonb DEFAULT '{}'::jsonb,
    pickup jsonb DEFAULT '{}'::jsonb,
    dropoff jsonb DEFAULT '{}'::jsonb,
    extras jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE deliveries OWNER TO olgalover;

--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: olgalover
--

CREATE SEQUENCE deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deliveries_id_seq OWNER TO olgalover;

--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: olgalover
--

ALTER SEQUENCE deliveries_id_seq OWNED BY deliveries.id;


--
-- Name: institutions; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE institutions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    legal_name character varying,
    uid_type character varying,
    uid character varying,
    type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE institutions OWNER TO olgalover;

--
-- Name: milestones; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE milestones (
    id bigint NOT NULL,
    trip_id uuid,
    name character varying,
    comments text,
    data jsonb DEFAULT '{}'::jsonb,
    gps_coordinates geography(Point,4326),
    created_at timestamp without time zone
);


ALTER TABLE milestones OWNER TO olgalover;

--
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: olgalover
--

CREATE SEQUENCE milestones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE milestones_id_seq OWNER TO olgalover;

--
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: olgalover
--

ALTER SEQUENCE milestones_id_seq OWNED BY milestones.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE orders (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    giver_id uuid,
    receiver_id uuid,
    expiration date,
    amount numeric(12,4) DEFAULT 0,
    bonified_amount numeric(12,4) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE orders OWNER TO olgalover;

--
-- Name: packages; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE packages (
    id bigint NOT NULL,
    delivery_id integer,
    weight integer,
    volume integer,
    cooling boolean DEFAULT false,
    description text,
    attachment_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity integer DEFAULT 1,
    fragile boolean DEFAULT false
);


ALTER TABLE packages OWNER TO olgalover;

--
-- Name: packages_id_seq; Type: SEQUENCE; Schema: public; Owner: olgalover
--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE packages_id_seq OWNER TO olgalover;

--
-- Name: packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: olgalover
--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE payments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    status character varying,
    amount numeric(10,2),
    collected_amount numeric(10,2),
    payable_type character varying,
    payable_id character varying,
    gateway character varying,
    gateway_id character varying,
    gateway_data jsonb DEFAULT '{}'::jsonb,
    notifications jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE payments OWNER TO olgalover;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying,
    last_name character varying,
    user_id uuid NOT NULL,
    preferences jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE profiles OWNER TO olgalover;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO olgalover;

--
-- Name: shippers; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE shippers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying,
    gender character varying,
    birth_date date,
    email character varying NOT NULL,
    phone_num character varying,
    photo character varying,
    active boolean DEFAULT false,
    verified boolean DEFAULT false,
    verified_at date,
    national_ids jsonb DEFAULT '{}'::jsonb,
    gateway character varying,
    gateway_id character varying NOT NULL,
    data jsonb DEFAULT '{}'::jsonb,
    minimum_requirements jsonb DEFAULT '{}'::jsonb,
    requirements jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_digest character varying,
    token_expire_at integer,
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_login_at timestamp without time zone,
    last_login_ip character varying
);


ALTER TABLE shippers OWNER TO olgalover;

--
-- Name: trips; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE trips (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipper_id uuid,
    status character varying,
    comments character varying,
    amount numeric(12,4) DEFAULT 0,
    gateway character varying,
    gateway_id character varying,
    gateway_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    steps jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE trips OWNER TO olgalover;

--
-- Name: users; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying,
    email character varying,
    password_digest character varying,
    token_expire_at integer,
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_login_at timestamp without time zone,
    last_login_ip character varying,
    active boolean DEFAULT false,
    confirmed boolean DEFAULT false,
    roles_mask integer,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE users OWNER TO olgalover;

--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE vehicles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipper_id uuid,
    model character varying NOT NULL,
    brand character varying,
    year integer,
    extras jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE vehicles OWNER TO olgalover;

--
-- Name: verifications; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE verifications (
    id bigint NOT NULL,
    verificable_type character varying,
    verificable_id uuid,
    data jsonb DEFAULT '{}'::jsonb,
    verified_at timestamp without time zone,
    verified_by uuid,
    expire boolean,
    expire_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE verifications OWNER TO olgalover;

--
-- Name: verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: olgalover
--

CREATE SEQUENCE verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE verifications_id_seq OWNER TO olgalover;

--
-- Name: verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: olgalover
--

ALTER SEQUENCE verifications_id_seq OWNED BY verifications.id;


--
-- Name: webhook_logs; Type: TABLE; Schema: public; Owner: olgalover
--

CREATE TABLE webhook_logs (
    id bigint NOT NULL,
    service character varying,
    path character varying(1024),
    parsed_body jsonb DEFAULT '{}'::jsonb,
    ip character varying,
    user_agent character varying,
    requested_at timestamp without time zone
);


ALTER TABLE webhook_logs OWNER TO olgalover;

--
-- Name: webhook_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: olgalover
--

CREATE SEQUENCE webhook_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE webhook_logs_id_seq OWNER TO olgalover;

--
-- Name: webhook_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: olgalover
--

ALTER SEQUENCE webhook_logs_id_seq OWNED BY webhook_logs.id;


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY deliveries ALTER COLUMN id SET DEFAULT nextval('deliveries_id_seq'::regclass);


--
-- Name: milestones id; Type: DEFAULT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY milestones ALTER COLUMN id SET DEFAULT nextval('milestones_id_seq'::regclass);


--
-- Name: packages id; Type: DEFAULT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--
-- Name: verifications id; Type: DEFAULT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY verifications ALTER COLUMN id SET DEFAULT nextval('verifications_id_seq'::regclass);


--
-- Name: webhook_logs id; Type: DEFAULT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY webhook_logs ALTER COLUMN id SET DEFAULT nextval('webhook_logs_id_seq'::regclass);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY addresses (id, institution_id, gps_coordinates, street_1, street_2, zip_code, city, state, country, contact_name, contact_cellphone, contact_email, telephone, open_hours, notes, created_at, updated_at, lookup, gateway, gateway_id, gateway_data) FROM stdin;
794d8b06-e0b2-442b-8949-806a86defafe    ebb0c30f-3999-466b-9175-6fb9c095ee7a    0101000020E61000009A99999999514EC0A54E4013617B40C0  Riobamba 739    \N  S2000   Rosario Santa Fe    AR      12345   karen@karen.com \N  \N  Notas   2018-03-01 20:42:11.449739  2018-03-01 20:42:11.449739  Riobamba 739, S2000 Rosario, Santa Fe, AR   Shippify    1746    {"data": {"id": 1746, "lat": -32.9639, "lng": -60.6375, "name": "123 - Test", "address": "Riobamba 739, S2000 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "karen@karen.com", "phone": "12345"}, "instructions": "Notas"}, "fetched_at": "2018-03-01T17:42:11.438-03:00"}
6c1f71f6-f0ad-4d66-85bb-7e753b16cedc    0502ad2e-b88f-4dc1-9c1f-d617d060aeb1    0101000020E61000009A99999999514EC0A54E4013617B40C0  Riobamba 739    \N  S2000   Rosario Santa Fe    AR  Carlos Fernandez    1536266811  karen@karen.com \N  \N  -   2018-03-01 20:42:11.468235  2018-03-01 20:42:11.468235  Riobamba 739, S2000 Rosario, Santa Fe, AR   Shippify    1739    {"data": {"id": 1739, "lat": "-32.9639", "lng": "-60.6375", "name": "126 - Test", "address": "Riobamba 739, S2000 Rosario, Santa Fe, AR", "contact": {"name": "Carlos Fernandez", "email": "karen@karen.com", "phone": "1536266811"}, "instructions": "-"}, "fetched_at": "2018-03-01T17:42:11.466-03:00"}
1dd6347f-e4bf-43d3-8ed1-0f69ddbcf000    be3dcfee-8b8e-4f56-bda5-05a4cba46489    0101000020E61000009CA223B9FC574EC0AC1C5A643B7740C0  Carriego 360    \N  S2002   Rosario Santa Fe    AR      34125647        \N  \N  Pasillo 2018-03-01 20:42:11.475857  2018-03-01 20:42:11.475857  Carriego 360, S2002 Rosario, Santa Fe, AR   Shippify    1749    {"data": {"id": 1749, "lat": -32.9315, "lng": -60.6874, "name": "213. Solcito", "address": "Carriego 360, S2002 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "", "phone": "34125647"}, "instructions": "Pasillo"}, "fetched_at": "2018-03-01T17:42:11.472-03:00"}
07256482-acef-4986-9258-17e0ef8c5bda    845f85aa-d10f-4e01-8d6a-303c91f941c2    0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0  Gorriti 6080    \N  S2007   Rosario Santa Fe    AR      0800 222 5657       \N  \N  -   2018-03-01 20:42:11.482748  2018-03-01 20:42:11.482748  Gorriti 6080, S2007 Rosario, Santa Fe, AR   Shippify    1748    {"data": {"id": 1748, "lat": -32.924, "lng": -60.7061, "name": "97 - San Cayetano", "address": "Gorriti 6080, S2007 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "", "phone": "0800 222 5657"}, "instructions": "-"}, "fetched_at": "2018-03-01T17:42:11.480-03:00"}
2e0d56c1-716d-4a29-b31d-07133ae6f719    4e506439-bfbb-4ceb-adc6-2705d43bc309    0101000020E61000009CA223B9FC574EC0E561A1D6347740C0  Carriego 340    \N  S2002   Rosario Santa Fe    AR      15342312    kari@nilus.org  \N  \N  -   2018-03-01 20:42:11.490397  2018-03-01 20:42:11.490397  Carriego 340, S2002 Rosario, Santa Fe, AR   Shippify    1747    {"data": {"id": 1747, "lat": -32.9313, "lng": -60.6874, "name": "BAR", "address": "Carriego 340, S2002 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "kari@nilus.org", "phone": "15342312"}, "instructions": "-"}, "fetched_at": "2018-03-01T17:42:11.488-03:00"}
ba417448-7905-4677-ad2f-619df289ccb8    27c999ed-6465-4d3a-9f70-85b7d6a14cad    0101000020E61000009CA223B9FC574EC0AC1C5A643B7740C0  Carriego 360    \N  S2002   Rosario Santa Fe    AR              \N  \N  -   2018-03-01 20:42:11.496252  2018-03-01 20:42:11.496252  Carriego 360, S2002 Rosario, Santa Fe, AR   Shippify    1744    {"data": {"id": 1744, "lat": -32.9315, "lng": -60.6874, "name": "BAR - 2", "address": "Carriego 360, S2002 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "", "phone": ""}, "instructions": "-"}, "fetched_at": "2018-03-01T17:42:11.494-03:00"}
e0e4cb2f-6a8f-42f8-b9a1-cf781615c714    b898d88e-7dd9-4d7b-8032-e9e939cb3cae    0101000020E61000009CA223B9FC574EC0AC1C5A643B7740C0  Carriego 360    \N  S2002   Rosario Santa Fe    AR      123 karen@karen.com \N  \N  Notas   2018-03-01 20:42:11.502158  2018-03-01 20:42:11.502158  Carriego 360, S2002 Rosario, Santa Fe, AR   Shippify    1745    {"data": {"id": 1745, "lat": -32.9315, "lng": -60.6874, "name": "BAR - 3", "address": "Carriego 360, S2002 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "karen@karen.com", "phone": "123"}, "instructions": "Notas"}, "fetched_at": "2018-03-01T17:42:11.500-03:00"}
36d14ce5-84d1-4100-9268-241737acf8b5    c2f36e03-70af-4c5d-9249-097d1d6776fc    0101000020E61000009A99999999514EC0A54E4013617B40C0  Riobamba 739    \N  S2000   Rosario Santa Fe    AR              \N  \N  -   2018-03-01 20:42:11.511775  2018-03-01 20:42:11.511775  Riobamba 739, S2000 Rosario, Santa Fe, AR   Shippify    1740    {"data": {"id": 1740, "lat": -32.9639, "lng": -60.6375, "name": "Test Karen", "address": "Riobamba 739, S2000 Rosario, Santa Fe, AR", "contact": {"name": "", "email": "", "phone": ""}, "instructions": "-"}, "fetched_at": "2018-03-01T17:42:11.508-03:00"}
1911010e-dc20-4ed1-bd40-de560901defa    b4913491-19ee-4537-8ac8-42e6eda9d790    \N  Carriego 360        S2002   Rosario Santa Fe    AR  Carla Fernandez 0351 15 677 8232        0341 527-8731   De 8hs a 17hs       2018-03-01 20:45:55.521831  2018-03-01 20:45:55.521831  \N  \N  \N  {}
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment development 2018-02-23 16:02:57.266135  2018-02-23 16:02:57.266135
\.


--
-- Data for Name: bank_accounts; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY bank_accounts (id, bank_name, number, type, cbu, shipper_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY deliveries (id, order_id, trip_id, amount, bonified_amount, origin_id, origin_gps_coordinates, destination_id, destination_gps_coordinates, status, created_at, updated_at, gateway, gateway_id, gateway_data, pickup, dropoff, extras) FROM stdin;
2   dc14b156-154a-4cab-b24a-ee48a8f464f4    1ecf100e-0349-49a8-8519-223424b78007    375.0000    \N  2e0d56c1-716d-4a29-b31d-07133ae6f719    0101000020E61000009CA223B9FC574EC0E561A1D6347740C0  6c1f71f6-f0ad-4d66-85bb-7e753b16cedc    0101000020E61000009A99999999514EC0A54E4013617B40C0  broadcasting    2018-03-01 21:12:59.50067   2018-03-02 21:42:35.801803  Shippify    t-nildev-36 {"id": "t-nildev-36", "items": [{"id": "2", "qty": 1, "name": "No perecederos", "size": 3, "fragile": false}, {"id": "3", "qty": 1, "name": "Frutas o verduras", "size": 3, "fragile": false}], "route": {"id": null}, "pickup": {"date": "2018-03-02T14:00:00.000Z"}, "rating": null, "status": 1, "_status": "processing", "company": "Nilus-dev", "courier": {"info": {"shipperId": null, "shipperName": null, "vehicleType": null, "vehicleModel": null, "vehicleLicensePlate": null}, "location": {"lat": 0, "lng": 0}}, "dropoff": {"date": "2018-03-02T15:00:00.000Z", "location": {"lat": -32.9639, "lng": -60.6375, "address": "Riobamba 739, S2000 Rosario, Santa Fe, AR"}}, "groupId": "1ecf100e-0349-49a8-8519-223424b7800", "distance": 8.2, "recipient": {"name": "Carlos fernandez", "email": "karen@karen.com", "phonenumber": "1536266811"}, "referenceId": "2", "delivery_feedback": ""}  {":notes": "-", ":place": "BAR", ":latlng": "-32.9313,-60.6874", ":address": {":id": "2e0d56c1-716d-4a29-b31d-07133ae6f719", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Carriego 340", ":street_2": null, ":zip_code": "S2002", ":telephone": null}, ":contact": {":name": "", ":email": "kari@nilus.org", ":cellphone": "15342312"}, ":open_hours": null}   {":notes": "-", ":place": "126 - Test", ":latlng": "-32.9639,-60.6375", ":address": {":id": "6c1f71f6-f0ad-4d66-85bb-7e753b16cedc", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Riobamba 739", ":street_2": null, ":zip_code": "S2000", ":telephone": null}, ":contact": {":name": "Carlos Fernandez", ":email": "karen@karen.com", ":cellphone": "1536266811"}, ":open_hours": null} {"options": []}
1   c2f4e772-a703-458f-9804-a377c5b05b03    30a6b332-7db0-4dba-ac5e-a077fb10e654    375.0000    \N  2e0d56c1-716d-4a29-b31d-07133ae6f719    0101000020E61000009CA223B9FC574EC0E561A1D6347740C0  07256482-acef-4986-9258-17e0ef8c5bda    0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0  broadcasting    2018-03-01 20:46:41.151984  2018-03-02 21:42:35.803596  Shippify    t-nildev-35 {"id": "t-nildev-35", "items": [{"id": "1", "qty": 1, "name": "Frescos y congelados", "size": 3, "fragile": false}], "route": {"id": null}, "pickup": {"date": "2018-03-02T13:00:00.000Z"}, "rating": null, "status": 1, "_status": "processing", "company": "Nilus-dev", "courier": {"info": {"shipperId": null, "shipperName": null, "vehicleType": null, "vehicleModel": null, "vehicleLicensePlate": null}, "location": {"lat": 0, "lng": 0}}, "dropoff": {"date": "2018-03-02T14:00:00.000Z", "location": {"lat": -32.924, "lng": -60.7061, "address": "Gorriti 6080, S2007 Rosario, Santa Fe, AR"}}, "groupId": "30a6b332-7db0-4dba-ac5e-a077fb10e65", "distance": 2.6, "recipient": {"name": "-", "email": "-", "phonenumber": "0800 222 5657"}, "referenceId": "1", "delivery_feedback": ""}    {":notes": "-", ":place": "BAR", ":latlng": "-32.9313,-60.6874", ":address": {":id": "2e0d56c1-716d-4a29-b31d-07133ae6f719", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Carriego 340", ":street_2": null, ":zip_code": "S2002", ":telephone": null}, ":contact": {":name": "", ":email": "kari@nilus.org", ":cellphone": "15342312"}, ":open_hours": null}   {":notes": "-", ":place": "97 - San Cayetano", ":latlng": "-32.924,-60.7061", ":address": {":id": "07256482-acef-4986-9258-17e0ef8c5bda", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Gorriti 6080", ":street_2": null, ":zip_code": "S2007", ":telephone": null}, ":contact": {":name": "", ":email": "", ":cellphone": "0800 222 5657"}, ":open_hours": null}   {"options": []}
3   e0935de2-0892-47c4-953c-bf2029163710    9315246b-e581-4b9b-9f01-b90eb2a7e40b    375.0000    \N  2e0d56c1-716d-4a29-b31d-07133ae6f719    0101000020E61000009CA223B9FC574EC0E561A1D6347740C0  07256482-acef-4986-9258-17e0ef8c5bda    0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0  processing  2018-03-05 22:22:29.079755  2018-03-05 22:22:29.166777  \N  \N  {}  {":notes": "-", ":place": "BAR", ":latlng": "-32.9313,-60.6874", ":address": {":id": "2e0d56c1-716d-4a29-b31d-07133ae6f719", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Carriego 340", ":street_2": null, ":zip_code": "S2002", ":telephone": null}, ":contact": {":name": "", ":email": "kari@nilus.org", ":cellphone": "15342312"}, ":open_hours": null}   {":notes": "-", ":place": "97 - San Cayetano", ":latlng": "-32.924,-60.7061", ":address": {":id": "07256482-acef-4986-9258-17e0ef8c5bda", ":city": "Rosario", ":state": "Santa Fe", ":country": "AR", ":street_1": "Gorriti 6080", ":street_2": null, ":zip_code": "S2007", ":telephone": null}, ":contact": {":name": "", ":email": "", ":cellphone": "0800 222 5657"}, ":open_hours": null}   {"options": []}
\.


--
-- Data for Name: institutions; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY institutions (id, name, legal_name, uid_type, uid, type, created_at, updated_at) FROM stdin;
ebb0c30f-3999-466b-9175-6fb9c095ee7a    123 - Test  \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.440134  2018-03-01 20:42:11.440134
0502ad2e-b88f-4dc1-9c1f-d617d060aeb1    126 - Test  \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.466528  2018-03-01 20:42:11.466528
be3dcfee-8b8e-4f56-bda5-05a4cba46489    213. Solcito    \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.474115  2018-03-01 20:42:11.474115
845f85aa-d10f-4e01-8d6a-303c91f941c2    97 - San Cayetano   \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.481266  2018-03-01 20:42:11.481266
4e506439-bfbb-4ceb-adc6-2705d43bc309    BAR \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.48874   2018-03-01 20:42:11.48874
27c999ed-6465-4d3a-9f70-85b7d6a14cad    BAR - 2 \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.49526   2018-03-01 20:42:11.49526
b898d88e-7dd9-4d7b-8032-e9e939cb3cae    BAR - 3 \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.500733  2018-03-01 20:42:11.500733
c2f36e03-70af-4c5d-9249-097d1d6776fc    Test Karen  \N  CUIT    \N  Institutions::Organization  2018-03-01 20:42:11.510031  2018-03-01 20:42:11.510031
ef46c307-307f-4fbf-ba74-54c5040c94f4    Carrefour   CARREFOUR ARGENTINA SOCIEDAD ANONIMA    CUIT    30-58462038-9   Institutions::Company   2018-03-01 20:45:55.437091  2018-03-01 20:45:55.437091
b4913491-19ee-4537-8ac8-42e6eda9d790    BAR FUNDACION BANCO DE ALIMENTOS DE ROSARIO CUIT    30-71000841-4   Institutions::Organization  2018-03-01 20:45:55.445543  2018-03-01 20:45:55.445543
048aaf02-4a7e-4c4b-98b0-364901bd47d8    Comedor Rosario Vera    Asociacion Civil Comedor Rosario Vera   CUIT    30-70815267-2   Institutions::Organization  2018-03-01 20:45:55.447701  2018-03-01 20:45:55.447701
\.


--
-- Data for Name: milestones; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY milestones (id, trip_id, name, comments, data, gps_coordinates, created_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY orders (id, giver_id, receiver_id, expiration, amount, bonified_amount, created_at, updated_at) FROM stdin;
c2f4e772-a703-458f-9804-a377c5b05b03    4e506439-bfbb-4ceb-adc6-2705d43bc309    845f85aa-d10f-4e01-8d6a-303c91f941c2    \N  1000.0000   \N  2018-03-01 20:46:41.09332   2018-03-01 20:46:41.09332
dc14b156-154a-4cab-b24a-ee48a8f464f4    4e506439-bfbb-4ceb-adc6-2705d43bc309    0502ad2e-b88f-4dc1-9c1f-d617d060aeb1    \N  5000.0000   \N  2018-03-01 21:12:59.495169  2018-03-01 21:12:59.495169
e0935de2-0892-47c4-953c-bf2029163710    4e506439-bfbb-4ceb-adc6-2705d43bc309    845f85aa-d10f-4e01-8d6a-303c91f941c2    \N  50000.0000  \N  2018-03-05 22:22:29.061853  2018-03-05 22:22:29.061853
\.


--
-- Data for Name: packages; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY packages (id, delivery_id, weight, volume, cooling, description, attachment_id, created_at, updated_at, quantity, fragile) FROM stdin;
1   1   100 \N  t   Frescos y congelados    \N  2018-03-01 20:46:41.186792  2018-03-01 20:46:41.186792  \N  f
2   2   120 \N  f   No perecederos  \N  2018-03-01 21:12:59.505141  2018-03-01 21:12:59.505141  \N  f
3   2   50  \N  f   Frutas o verduras   \N  2018-03-01 21:12:59.508147  2018-03-01 21:12:59.508147  \N  f
4   3   1200    \N  t   Frescos y congelados    \N  2018-03-05 22:22:29.101999  2018-03-05 22:22:29.101999  \N  f
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY payments (id, status, amount, collected_amount, payable_type, payable_id, gateway, gateway_id, gateway_data, notifications, created_at, updated_at) FROM stdin;
cc0b0a8f-62b7-430c-a842-b1d264e0db7b    pending 1000.00 \N  Order   c2f4e772-a703-458f-9804-a377c5b05b03    Mercadopago 13555739    {":id": 13555739, ":card": {}, ":order": {}, ":payer": {":id": null, ":type": "guest", ":email": "test_user_92173722@testuser.com", ":phone": {":number": "1111-1111", ":area_code": "01", ":extension": ""}, ":last_name": "Test", ":first_name": "Test", ":entity_type": null, ":identification": {":type": "DNI", ":number": "1111111"}}, ":status": "pending", ":barcode": {":type": "Code128C", ":width": 1, ":height": 30, ":content": "33350088000000000MP313555740100100000181130582"}, ":refunds": [], ":acquirer": null, ":captured": true, ":metadata": {}, ":issuer_id": null, ":live_mode": false, ":sponsor_id": null, ":binary_mode": false, ":currency_id": "ARS", ":description": "NILUS/BAR - Pago por la orden #c2f4e772-a703-458f-9804-a377c5b05b03", ":fee_details": [], ":collector_id": 316519508, ":date_created": "2018-04-23T16:15:22.000-04:00", ":installments": 1, ":coupon_amount": 0, ":date_approved": null, ":status_detail": "pending_waiting_payment", ":operation_type": "regular_payment", ":additional_info": {}, ":merchant_number": null, ":payment_type_id": "ticket", ":processing_mode": "aggregator", ":counter_currency": null, ":deduction_schema": null, ":notification_url": null, ":date_last_updated": "2018-04-23T16:15:22.000-04:00", ":payment_method_id": "pagofacil", ":authorization_code": null, ":date_of_expiration": null, ":external_reference": "cc0b0a8f-62b7-430c-a842-b1d264e0db7b", ":money_release_date": null, ":transaction_amount": 1000, ":merchant_account_id": null, ":transaction_details": {":overpaid_amount": 0, ":total_paid_amount": 1000, ":verification_code": "13555740", ":acquirer_reference": null, ":installment_amount": 0, ":net_received_amount": 0, ":external_resource_url": "http://www.mercadopago.com/mla/sandbox/payments/ticket/helper?payment_method=pagofacil", ":financial_institution": null, ":payable_deferral_period": null, ":payment_method_reference_id": "13555740"}, ":money_release_schema": null, ":statement_descriptor": null, ":call_for_authorize_id": null, ":acquirer_reconciliation": [], ":differential_pricing_id": null, ":transaction_amount_refunded": 0} {}  2018-04-23 20:13:52.473593  2018-04-23 20:19:06.059294
3dede010-183b-452c-b3e4-4f6be3ff2445    pending 5000.00 \N  Order   dc14b156-154a-4cab-b24a-ee48a8f464f4    Mercadopago 13555976    {":id": 13555976, ":card": {}, ":order": {}, ":payer": {":id": null, ":type": "guest", ":email": "test_user_92173722@testuser.com", ":phone": {":number": "1111-1111", ":area_code": "01", ":extension": ""}, ":last_name": "Test", ":first_name": "Test", ":entity_type": null, ":identification": {":type": "DNI", ":number": "1111111"}}, ":status": "pending", ":barcode": {":type": "Code128C", ":width": 1, ":height": 30, ":content": "33350088000000000MP313555977100500000181130539"}, ":refunds": [], ":acquirer": null, ":captured": true, ":metadata": {}, ":issuer_id": null, ":live_mode": false, ":sponsor_id": null, ":binary_mode": false, ":currency_id": "ARS", ":description": "NILUS/BAR - Pago por la orden #dc14b156-154a-4cab-b24a-ee48a8f464f4", ":fee_details": [], ":collector_id": 316519508, ":date_created": "2018-04-23T16:26:59.000-04:00", ":installments": 1, ":coupon_amount": 0, ":date_approved": null, ":status_detail": "pending_waiting_payment", ":operation_type": "regular_payment", ":additional_info": {}, ":merchant_number": null, ":payment_type_id": "ticket", ":processing_mode": "aggregator", ":counter_currency": null, ":deduction_schema": null, ":notification_url": "http://884a6d7c.ngrok.io/webhooks/mercadopago/payment/3dede010-183b-452c-b3e4-4f6be3ff2445", ":date_last_updated": "2018-04-23T16:26:59.000-04:00", ":payment_method_id": "pagofacil", ":authorization_code": null, ":date_of_expiration": null, ":external_reference": "3dede010-183b-452c-b3e4-4f6be3ff2445", ":money_release_date": null, ":transaction_amount": 5000, ":merchant_account_id": null, ":transaction_details": {":overpaid_amount": 0, ":total_paid_amount": 5000, ":verification_code": "13555977", ":acquirer_reference": null, ":installment_amount": 0, ":net_received_amount": 0, ":external_resource_url": "http://www.mercadopago.com/mla/sandbox/payments/ticket/helper?payment_method=pagofacil", ":financial_institution": null, ":payable_deferral_period": null, ":payment_method_reference_id": "13555977"}, ":money_release_schema": null, ":statement_descriptor": null, ":call_for_authorize_id": null, ":acquirer_reconciliation": [], ":differential_pricing_id": null, ":transaction_amount_refunded": 0} {}  2018-04-23 20:26:58.330041  2018-04-23 20:27:00.143488
1b8e04e8-176d-469a-81ae-8f88f7d12131    pending 100.00  \N  Order   e0935de2-0892-47c4-953c-bf2029163710    Mercadopago 13571239    {":id": 13571239, ":card": {}, ":order": {}, ":payer": {":id": null, ":type": "guest", ":email": "test_user_92173722@testuser.com", ":phone": {":number": "1111-1111", ":area_code": "01", ":extension": ""}, ":last_name": "Test", ":first_name": "Test", ":entity_type": null, ":identification": {":type": "DNI", ":number": "1111111"}}, ":status": "pending", ":barcode": {":type": "Code128C", ":width": 1, ":height": 30, ":content": "33350088000000000MP313571240100010000181140591"}, ":refunds": [], ":acquirer": null, ":captured": true, ":metadata": {}, ":issuer_id": null, ":live_mode": false, ":sponsor_id": null, ":binary_mode": false, ":currency_id": "ARS", ":description": "NILUS/BAR - Pago por la orden #e0935de2-0892-47c4-953c-bf2029163710", ":fee_details": [], ":collector_id": 316519508, ":date_created": "2018-04-24T15:19:31.000-04:00", ":installments": 1, ":coupon_amount": 0, ":date_approved": null, ":status_detail": "pending_waiting_payment", ":operation_type": "regular_payment", ":additional_info": {}, ":merchant_number": null, ":payment_type_id": "ticket", ":processing_mode": "aggregator", ":counter_currency": null, ":deduction_schema": null, ":notification_url": "http://884a6d7c.ngrok.io/webhooks/mercadopago/payment/1b8e04e8-176d-469a-81ae-8f88f7d12131", ":date_last_updated": "2018-04-24T15:19:31.000-04:00", ":payment_method_id": "pagofacil", ":authorization_code": null, ":date_of_expiration": null, ":external_reference": "1b8e04e8-176d-469a-81ae-8f88f7d12131", ":money_release_date": null, ":transaction_amount": 100, ":merchant_account_id": null, ":transaction_details": {":overpaid_amount": 0, ":total_paid_amount": 100, ":verification_code": "13571240", ":acquirer_reference": null, ":installment_amount": 0, ":net_received_amount": 0, ":external_resource_url": "http://www.mercadopago.com/mla/sandbox/payments/ticket/helper?payment_method=pagofacil", ":financial_institution": null, ":payable_deferral_period": null, ":payment_method_reference_id": "13571240"}, ":money_release_schema": null, ":statement_descriptor": null, ":call_for_authorize_id": null, ":acquirer_reconciliation": [], ":differential_pricing_id": null, ":transaction_amount_refunded": 0}   {}  2018-04-24 19:19:30.465209  2018-04-24 19:19:32.315244
681e8ab0-88e5-4381-bdb6-15bed45acc5d    400 375.00  \N  Delivery    3   Mercadopago \N  {":cause": [{":code": 2034, ":data": null, ":description": "Invalid users involved"}], ":error": "bad_request", ":status": 400, ":message": "Invalid users involved"}   {}  2018-04-24 19:22:30.980056  2018-04-24 19:22:32.330508
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY profiles (id, first_name, last_name, user_id, preferences, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY schema_migrations (version) FROM stdin;
20171026160700
20171026165316
20171031163630
20171108184820
20171108225639
20171122123510
20171124190242
20171129140017
20171204201143
20180117191346
20180125135954
20180421135856
20180424163911
20180428151347
\.


--
-- Data for Name: shippers; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY shippers (id, first_name, last_name, gender, birth_date, email, phone_num, photo, active, verified, verified_at, national_ids, gateway, gateway_id, data, minimum_requirements, requirements, created_at, updated_at, password_digest, token_expire_at, login_count, failed_login_count, last_login_at, last_login_ip) FROM stdin;
1d5177d0-1341-41bc-8514-61490ecbd1b1    Cou \N  \N  \N  constanza@winguweb.org  +541131565412   \N  t   t   \N  {}  Shippify    40600   {":data": {"id": 40600, "city": "Rosario", "name": "Cou ", "type": 1, "email": "constanza@winguweb.org", "phone": "+541131565412", "status": 3, "recordsfiltered": 2, "is_documentation_verified": 1}, ":details": {"email": "constanza@winguweb.org", "doc_id": null, "mobile": "+541131565412", "city_id": 20, "capacity": 3, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 1524, "created_dt": "2018-02-21T15:36:22.000Z", "first_name": "Cou", "shipper_id": 40600, "vehicle_id": null, "company_name": "Nilus-dev", "vehicle_type": null, "license_plate": null, "vehicle_model": null, "verify_status": 0, "vehicle_creation": null}, ":fetched_at": {"^t": 1519936941.584}} {}  {}  2018-03-01 20:42:21.584662  2018-04-24 19:15:16.406557  $2a$10$bps/y2AyqoSz28SJbSOTZ.Dozb4jzPLI4KP4XRh.1cNxtWdyRf0he    \N  0   0   \N  \N
da9a5028-598f-461f-9368-b5a6798b7e29    Cavi    \N  \N  \N  agustin+shipper@winguweb.org    +5430511002 \N  t   t   \N  {}  Shippify    38758   {":data": {"id": 38758, "city": "Rosario", "name": "Cavi ", "type": 2, "email": "agustin+shipper@winguweb.org", "phone": "+5430511002", "status": 3, "recordsfiltered": 2, "is_documentation_verified": 1}, ":details": {"email": "agustin+shipper@winguweb.org", "doc_id": null, "mobile": "+5430511002", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 1524, "created_dt": "2018-01-23T15:52:46.000Z", "first_name": "Cavi", "shipper_id": 38758, "vehicle_id": 10985, "company_name": "Nilus-dev", "vehicle_type": "Volkswagen - Kombi 1.6", "license_plate": "-", "vehicle_model": "1979", "verify_status": 0, "vehicle_creation": "2018-02-15T19:40:07.000Z"}, ":fetched_at": {"^t": 1519936941.511}}   {}  {}  2018-03-01 20:42:21.512111  2018-04-24 19:15:16.473699  $2a$10$KegNVTBofEJJYHovzbcOHuCM3chfRp4ElQOKR2xIi9CZcD6Htvv2q    \N  0   0   \N  \N
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: trips; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY trips (id, shipper_id, status, comments, amount, gateway, gateway_id, gateway_data, created_at, updated_at, steps) FROM stdin;
1ecf100e-0349-49a8-8519-223424b78007    da9a5028-598f-461f-9368-b5a6798b7e29    broadcasting        375.0000    Shippify    t-nildev-36 {"id": "t-nildev-36", "city": {"id": "20", "name": "Rosario"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nildev-36", "activityType": "pickup"}, {"deliveryId": "t-nildev-36", "activityType": "dropoff"}], "distances": [8.2], "deliveries": [{"id": "t-nildev-36", "fare": {"cash": 0, "service": 0, "delivery": 0, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "-", "email": "kari@nilus.org", "phonenumber": "15342312"}, "location": {"address": "Carriego 340, S2002 Rosario, Santa Fe, AR", "latitude": -32.9313, "longitude": -60.6874}, "timeWindow": {"end": "2018-03-02T15:00:00.000Z", "start": "2018-03-02T14:00:00.000Z"}}, "status": "broadcasting", "company": {"id": 1524, "name": "Nilus-dev"}, "dropoff": {"extras": [], "contact": {"name": "Carlos fernandez", "email": "karen@karen.com", "phonenumber": "1536266811"}, "location": {"address": "Riobamba 739, S2000 Rosario, Santa Fe, AR", "latitude": -32.9639, "longitude": -60.6375}, "timeWindow": {"end": "2018-03-02T16:00:00.000Z", "start": "2018-03-02T15:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"id": "2", "name": "No perecederos", "size": 3, "quantity": 1}, {"id": "3", "name": "Frutas o verduras", "size": 3, "quantity": 1}]}, "receiver": {"name": "Carlos fernandez", "email": "karen@karen.com", "phonenumber": "1536266811"}, "substatus": "broadcasting", "referenceId": "2"}], "referenceId": "2", "currencyCode": "ARS", "minimumCapacity": "medium"}    2018-03-01 21:12:59.54537   2018-03-02 21:43:32.880377  [{"action": "pickup", "schedule": {"end": "2018-03-02T23:00:00.000Z", "start": "2018-03-02T22:00:00.000Z"}, "delivery_id": 2}, {"action": "dropoff", "schedule": {"end": "2018-03-03T01:00:00.000Z", "start": "2018-03-03T00:00:00.000Z"}, "delivery_id": 2}]
30a6b332-7db0-4dba-ac5e-a077fb10e654    \N  broadcasting        375.0000    Shippify    t-nildev-35 {"id": "t-nildev-35", "city": {"id": "20", "name": "Rosario"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nildev-35", "activityType": "pickup"}, {"deliveryId": "t-nildev-35", "activityType": "dropoff"}], "distances": [2.6], "deliveries": [{"id": "t-nildev-35", "fare": {"cash": 0, "service": 0, "delivery": 0, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "-", "email": "kari@nilus.org", "phonenumber": "15342312"}, "location": {"address": "Carriego 340, S2002 Rosario, Santa Fe, AR", "latitude": -32.9313, "longitude": -60.6874}, "timeWindow": {"end": "2018-03-02T14:00:00.000Z", "start": "2018-03-02T13:00:00.000Z"}}, "status": "broadcasting", "company": {"id": 1524, "name": "Nilus-dev"}, "dropoff": {"extras": [], "contact": {"name": "-", "email": "-", "phonenumber": "0800 222 5657"}, "location": {"address": "Gorriti 6080, S2007 Rosario, Santa Fe, AR", "latitude": -32.924, "longitude": -60.7061}, "timeWindow": {"end": "2018-03-02T15:00:00.000Z", "start": "2018-03-02T14:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"id": "1", "name": "Frescos y congelados", "size": 3, "quantity": 1}]}, "receiver": {"name": "-", "email": "-", "phonenumber": "0800 222 5657"}, "substatus": "broadcasting", "referenceId": "1"}], "referenceId": "1", "currencyCode": "ARS", "minimumCapacity": "medium"}   2018-03-01 20:46:41.264901  2018-03-02 21:49:58.813512  [{"action": "pickup", "schedule": {"end": "2018-03-02T23:00:00.000Z", "start": "2018-03-02T22:00:00.000Z"}, "delivery_id": 1}, {"action": "dropoff", "schedule": {"end": "2018-03-03T00:30:00.000Z", "start": "2018-03-02T23:30:00.000Z"}, "delivery_id": 1}]
9315246b-e581-4b9b-9f01-b90eb2a7e40b    \N  \N      375.0000    \N  \N  {}  2018-03-05 22:22:29.153066  2018-03-05 22:22:29.153066  [{"action": "pickup", "schedule": {"end": "2018-03-06T12:00:00.000Z", "start": "2018-03-06T12:00:00.000Z"}, "delivery_id": 3}, {"action": "dropoff", "schedule": {"end": "2018-03-06T12:00:00.000Z", "start": "2018-03-06T12:00:00.000Z"}, "delivery_id": 3}]
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY users (id, username, email, password_digest, token_expire_at, login_count, failed_login_count, last_login_at, last_login_ip, active, confirmed, roles_mask, settings, deleted_at, created_at, updated_at) FROM stdin;
e85e9cc3-3837-4b30-b8a4-c9661b50f980    karen   karen@winguweb.org  $2a$10$haPrtsAm2oWkgEBTYstTZeK47OjubhQgMDNR8oQpnjGKZQHotkO0G    \N  0   0   \N  \N  f   f   \N  {}  \N  2018-03-01 20:45:55.18809   2018-03-01 20:45:55.18809
c4163f96-e3fa-47a8-b31c-c0c84299da00    carlos  carlos@winguweb.org $2a$10$nlS4UmXGHbTCwAMXGAm4.ef9izo4ZGDf6VuEuYhjP7lMnpypDaI7G    \N  0   0   \N  \N  f   f   \N  {}  \N  2018-03-01 20:45:55.40389   2018-03-01 20:45:55.40389
9f242773-7bb6-40ca-950c-c80f47992f49    cavi    agustin@winguweb.org    $2a$10$r44sds3xrnQItm5KaIIQ3uyXh1ZiuSgO0L6vtnvBChuWSvWPdWGi2    1520374453  3   0   2018-03-05 22:14:13.515544  127.0.0.1   f   f   \N  {}  \N  2018-03-01 20:45:55.263013  2018-03-05 22:14:13.517094
04a4244f-8070-44d9-a7b3-4d8f7edbd6b0    facu    facundo@winguweb.org    $2a$10$PEEaIhiIybHCWiDPk68RvOm6liXR46UtX2EgAQvryTe4P6ga3bJ2O    1525376624  3   0   2018-05-02 19:43:44.873616  127.0.0.1   f   f   \N  {}  \N  2018-03-01 20:45:55.334638  2018-05-02 19:43:44.875044
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY vehicles (id, shipper_id, model, brand, year, extras, created_at, updated_at) FROM stdin;
37ba82b7-684b-4058-8454-c3fd41d76c83    da9a5028-598f-461f-9368-b5a6798b7e29    Volkswagen - Kombi 1.6  \N  1979    {"capacity": 5, "gateway_id": 10985}    2018-03-01 20:42:21.519807  2018-03-01 20:42:21.519807
\.


--
-- Data for Name: verifications; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY verifications (id, verificable_type, verificable_id, data, verified_at, verified_by, expire, expire_at, created_at, updated_at) FROM stdin;
1   Vehicle 37ba82b7-684b-4058-8454-c3fd41d76c83    {":type": "license_plate", ":information": {":number": "-"}}    \N  \N  \N  \N  2018-03-01 20:42:21.522157  2018-03-01 20:42:21.522157
\.


--
-- Data for Name: webhook_logs; Type: TABLE DATA; Schema: public; Owner: olgalover
--

COPY webhook_logs (id, service, path, parsed_body, ip, user_agent, requested_at) FROM stdin;
1   mercadopago /webhooks/mercadopago/payment/3dede010-183b-452c-b3e4-4f6be3ff2445?type=payment&data.id=13555976    {"id": 277073089, "data": {"id": "13555976"}, "type": "payment", "uuid": "3dede010-183b-452c-b3e4-4f6be3ff2445", "action": "payment_notification", "data.id": "13555976", "user_id": 316519508, "protocol": "http", "live_mode": false, "controller": "webhooks/mercadopago", "api_version": "v1", "mercadopago": {"id": 277073089, "data": {"id": "13555976"}, "type": "payment", "action": "payment.created", "user_id": 316519508, "live_mode": false, "api_version": "v1", "date_created": "2018-04-23T16:26:59.000-04:00"}, "date_created": "2018-04-23T16:26:59.000-04:00"}   216.33.196.4    MercadoPago WebHook v1.0 payment    2018-04-23 20:27:00.423
\.


--
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: olgalover
--

SELECT pg_catalog.setval('deliveries_id_seq', 3, true);


--
-- Name: milestones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: olgalover
--

SELECT pg_catalog.setval('milestones_id_seq', 1, false);


--
-- Name: packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: olgalover
--

SELECT pg_catalog.setval('packages_id_seq', 4, true);


--
-- Name: verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: olgalover
--

SELECT pg_catalog.setval('verifications_id_seq', 1, true);


--
-- Name: webhook_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: olgalover
--

SELECT pg_catalog.setval('webhook_logs_id_seq', 1, true);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--
-- Name: institutions institutions_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: packages packages_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: shippers shippers_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY shippers
    ADD CONSTRAINT shippers_pkey PRIMARY KEY (id);


--
-- Name: trips trips_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: verifications verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);


--
-- Name: webhook_logs webhook_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY webhook_logs
    ADD CONSTRAINT webhook_logs_pkey PRIMARY KEY (id);


--
-- Name: index_addresses_on_gateway_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_addresses_on_gateway_data ON addresses USING gin (gateway_data);


--
-- Name: index_addresses_on_gps_coordinates; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_addresses_on_gps_coordinates ON addresses USING gist (gps_coordinates);


--
-- Name: index_addresses_on_institution_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_addresses_on_institution_id ON addresses USING btree (institution_id);


--
-- Name: index_bank_accounts_on_shipper_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_bank_accounts_on_shipper_id ON bank_accounts USING btree (shipper_id);


--
-- Name: index_deliveries_on_destination_gps_coordinates; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_destination_gps_coordinates ON deliveries USING gist (destination_gps_coordinates);


--
-- Name: index_deliveries_on_destination_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_destination_id ON deliveries USING btree (destination_id);


--
-- Name: index_deliveries_on_dropoff; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_dropoff ON deliveries USING gin (dropoff);


--
-- Name: index_deliveries_on_extras; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_extras ON deliveries USING gin (extras);


--
-- Name: index_deliveries_on_gateway_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_gateway_data ON deliveries USING gin (gateway_data);


--
-- Name: index_deliveries_on_order_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_order_id ON deliveries USING btree (order_id);


--
-- Name: index_deliveries_on_origin_gps_coordinates; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_origin_gps_coordinates ON deliveries USING gist (origin_gps_coordinates);


--
-- Name: index_deliveries_on_origin_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_origin_id ON deliveries USING btree (origin_id);


--
-- Name: index_deliveries_on_pickup; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_pickup ON deliveries USING gin (pickup);


--
-- Name: index_deliveries_on_trip_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_deliveries_on_trip_id ON deliveries USING btree (trip_id);


--
-- Name: index_milestones_on_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_milestones_on_data ON milestones USING gin (data);


--
-- Name: index_milestones_on_gps_coordinates; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_milestones_on_gps_coordinates ON milestones USING gist (gps_coordinates);


--
-- Name: index_milestones_on_trip_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_milestones_on_trip_id ON milestones USING btree (trip_id);


--
-- Name: index_orders_on_giver_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_orders_on_giver_id ON orders USING btree (giver_id);


--
-- Name: index_orders_on_receiver_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_orders_on_receiver_id ON orders USING btree (receiver_id);


--
-- Name: index_packages_on_attachment_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_packages_on_attachment_id ON packages USING btree (attachment_id);


--
-- Name: index_packages_on_delivery_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_packages_on_delivery_id ON packages USING btree (delivery_id);


--
-- Name: index_payments_on_gateway_and_gateway_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_payments_on_gateway_and_gateway_id ON payments USING btree (gateway, gateway_id);


--
-- Name: index_payments_on_gateway_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_payments_on_gateway_data ON payments USING gin (gateway_data);


--
-- Name: index_payments_on_notifications; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_payments_on_notifications ON payments USING gin (notifications);


--
-- Name: index_payments_on_payable_type_and_payable_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_payments_on_payable_type_and_payable_id ON payments USING btree (payable_type, payable_id);


--
-- Name: index_profiles_on_preferences; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_profiles_on_preferences ON profiles USING gin (preferences);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_shippers_on_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_shippers_on_data ON shippers USING gin (data);


--
-- Name: index_shippers_on_minimum_requirements; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_shippers_on_minimum_requirements ON shippers USING gin (minimum_requirements);


--
-- Name: index_shippers_on_national_ids; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_shippers_on_national_ids ON shippers USING gin (national_ids);


--
-- Name: index_shippers_on_requirements; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_shippers_on_requirements ON shippers USING gin (requirements);


--
-- Name: index_trips_on_gateway_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_trips_on_gateway_data ON trips USING gin (gateway_data);


--
-- Name: index_trips_on_shipper_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_trips_on_shipper_id ON trips USING btree (shipper_id);


--
-- Name: index_trips_on_steps; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_trips_on_steps ON trips USING gin (steps);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_roles_mask; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_users_on_roles_mask ON users USING btree (roles_mask);


--
-- Name: index_users_on_settings; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_users_on_settings ON users USING gin (settings);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: index_vehicles_on_extras; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_vehicles_on_extras ON vehicles USING gin (extras);


--
-- Name: index_vehicles_on_shipper_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_vehicles_on_shipper_id ON vehicles USING btree (shipper_id);


--
-- Name: index_verifications_on_data; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_verifications_on_data ON verifications USING gin (data);


--
-- Name: index_verifications_on_verificable_type_and_verificable_id; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_verifications_on_verificable_type_and_verificable_id ON verifications USING btree (verificable_type, verificable_id);


--
-- Name: index_webhook_logs_on_parsed_body; Type: INDEX; Schema: public; Owner: olgalover
--

CREATE INDEX index_webhook_logs_on_parsed_body ON webhook_logs USING gin (parsed_body);


--
-- Name: vehicles fk_rails_15393ee91e; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT fk_rails_15393ee91e FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--
-- Name: deliveries fk_rails_3eba625948; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT fk_rails_3eba625948 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: trips fk_rails_64fc3626a2; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_64fc3626a2 FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--
-- Name: addresses fk_rails_6a5d8705d2; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT fk_rails_6a5d8705d2 FOREIGN KEY (institution_id) REFERENCES institutions(id);


--
-- Name: deliveries fk_rails_6ec721b21e; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT fk_rails_6ec721b21e FOREIGN KEY (trip_id) REFERENCES trips(id);


--
-- Name: bank_accounts fk_rails_91b14e7155; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY bank_accounts
    ADD CONSTRAINT fk_rails_91b14e7155 FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--
-- Name: packages fk_rails_e7fe3e94f2; Type: FK CONSTRAINT; Schema: public; Owner: olgalover
--

ALTER TABLE ONLY packages
    ADD CONSTRAINT fk_rails_e7fe3e94f2 FOREIGN KEY (delivery_id) REFERENCES deliveries(id);


--
-- PostgreSQL database dump complete
--

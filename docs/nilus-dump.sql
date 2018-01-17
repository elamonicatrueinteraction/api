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




--

--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);




--

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




--

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
    gateway_data jsonb DEFAULT '{}'::jsonb
);




--

--

CREATE SEQUENCE deliveries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--

--

ALTER SEQUENCE deliveries_id_seq OWNED BY deliveries.id;


--

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




--

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




--

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




--

--

CREATE SEQUENCE packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--

--

ALTER SEQUENCE packages_id_seq OWNED BY packages.id;


--

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




--

--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);




--

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
    updated_at timestamp without time zone NOT NULL
);




--

--

CREATE TABLE trips (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    shipper_id uuid,
    status character varying,
    comments character varying,
    amount numeric(12,4) DEFAULT 0,
    schedule_at timestamp without time zone,
    pickups jsonb DEFAULT '[]'::jsonb NOT NULL,
    dropoffs jsonb DEFAULT '[]'::jsonb NOT NULL,
    gateway character varying,
    gateway_id character varying,
    gateway_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);




--

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




--

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




--

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




--

--

CREATE SEQUENCE verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




--

--

ALTER SEQUENCE verifications_id_seq OWNED BY verifications.id;


--

--

ALTER TABLE ONLY deliveries ALTER COLUMN id SET DEFAULT nextval('deliveries_id_seq'::regclass);


--

--

ALTER TABLE ONLY packages ALTER COLUMN id SET DEFAULT nextval('packages_id_seq'::regclass);


--

--

ALTER TABLE ONLY verifications ALTER COLUMN id SET DEFAULT nextval('verifications_id_seq'::regclass);


--

--

COPY addresses (id, institution_id, gps_coordinates, street_1, street_2, zip_code, city, state, country, contact_name, contact_cellphone, contact_email, telephone, open_hours, notes, created_at, updated_at, lookup, gateway, gateway_id, gateway_data) FROM stdin;
da180da3-937f-492f-b99a-6d671834a610	07238384-5715-43e8-b3ec-654b7bb40876	0101000020E61000000000000000584EC0ECC039234A7B40C0	Rueda 4265	\N	\N	Rosario	Santa Fe	Argentina	Sandra Arce	153480194		\N	\N	Pasillo	2017-11-30 17:49:21.078939	2017-11-30 17:49:21.078939	Rueda 4265, Rosario, Santa Fe, Argentina	Shippify	1542	{"data": {"id": 1542, "lat": -32.9632, "lng": -60.6875, "name": "213 - Solcito", "address": "Rueda 4265, Rosario, Santa Fe, Argentina", "contact": {"name": "Sandra Arce", "email": "", "phone": "153480194"}, "instructions": "Pasillo"}, "fetched_at": "2017-11-30T14:49:21.075-03:00"}
975e51f6-c9bf-4ddc-86eb-0f8ab995b3fd	de2166cc-3bea-467e-a4e6-c15f4ec5bcd3	0101000020E6100000D34D621058514EC0022B8716D97E40C0	Medici 4620	\N	S2001GKB	Rosario	Santa Fe	Argentina	Roxana Mansilla 	156936337		\N	\N	-	2017-11-30 17:49:21.084978	2017-11-30 17:49:21.084978	Medici 4620, S2001GKB Rosario, Santa Fe, Argentina	Shippify	1537	{"data": {"id": 1537, "lat": "-32.991", "lng": "-60.6355", "name": "223 - Asociación Civil Alas Para Crecer", "address": "Medici 4620, S2001GKB Rosario, Santa Fe, Argentina", "contact": {"name": "Roxana Mansilla ", "email": "", "phone": "156936337"}, "instructions": "-"}, "fetched_at": "2017-11-30T14:49:21.083-03:00"}
7f891cb3-ce32-45aa-bd9b-6d705f060ef7	2fd23688-d680-4730-ba7e-3433c02f375a	0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0	Gorriti 6080	\N	S2007BQT	Rosario	Santa Fe	Argentina	Mirta Barrios	155484625		\N	\N	-	2017-11-30 17:49:21.08895	2017-11-30 17:49:21.08895	Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina	Shippify	1543	{"data": {"id": 1543, "lat": -32.924, "lng": -60.7061, "name": "97 - San Cayetano", "address": "Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina", "contact": {"name": "Mirta Barrios", "email": "", "phone": "155484625"}, "instructions": "-"}, "fetched_at": "2017-11-30T14:49:21.087-03:00"}
8ea6c4fb-4f39-4905-a133-f132909e5bde	580921ef-6526-4e5b-8f85-5a385b024d64	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	Pres. Quintana 2173	\N	S2001ARQ	Rosario	Santa Fe	Argentina	Isabel Berizzo	156179787		\N	\N	-	2017-11-30 17:49:21.092899	2017-11-30 17:49:21.092899	Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina	Shippify	1461	{"data": {"id": 1461, "lat": "-32.9799", "lng": "-60.6619", "name": "Asociación Civil Evita Sol Naciente", "address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "contact": {"name": "Isabel Berizzo", "email": "", "phone": "156179787"}, "instructions": "-"}, "fetched_at": "2017-11-30T14:49:21.091-03:00"}
6d52cf7d-ffa5-444e-bd57-b709ebf588f9	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	Carriego 360	\N	S2002	Rosario	Santa Fe	Argentina	Karina Campos	5491167481432	karinacamposrodriguez@gmail.com	\N	\N	-	2017-11-30 17:49:21.096758	2017-11-30 17:49:21.096758	Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina	Shippify	1337	{"data": {"id": 1337, "lat": -32.9321, "lng": -60.6874, "name": "BAR", "address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "phone": "5491167481432"}, "instructions": "-"}, "fetched_at": "2017-11-30T14:49:21.095-03:00"}
fd58650b-5ab8-4c81-960e-4915160130e1	\N	0101000020E61000002506819543534EC00D71AC8BDB7840C0	\N	\N	\N	Rosario	Santa Fe Province	Argentina	Pablo	999	pablo@nilus.org	\N	\N	\N	2017-11-30 17:49:36.182468	2017-11-30 17:49:36.182468	Rosario, Santa Fe Province, Argentina	Shippify	\N	{"data": {"address": "Rosario, Santa Fe Province, Argentina", "contact": {"name": "Pablo", "email": "pablo@nilus.org", "phonenumber": "999"}, "latitude": -32.9442, "longitude": -60.6505}, "fetched_at": "2017-11-30T14:49:36.182-03:00"}
6755cdf1-203f-4bc5-9b06-5cf79dd4bd5e	\N	0101000020E6100000E10B93A982394DC0462575029A5041C0	\N	\N	Malvinas	Argentinas 456	C1406 CABA	Argentina	Karina campos	1567481432	jejimenez@gmail.com	\N	\N	\N	2017-11-30 17:49:39.457634	2017-11-30 17:49:39.457634	Malvinas Argentinas 456, C1406 CABA, Argentina	Shippify	\N	{"data": {"address": "Malvinas Argentinas 456, C1406 CABA, Argentina", "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "1567481432"}, "latitude": -34.6297, "longitude": -58.4493}, "fetched_at": "2017-11-30T14:49:39.457-03:00"}
e8bec291-eced-4bf1-bc86-e95668f71beb	\N	0101000020E6100000832F4CA60A3E4DC0B6847CD0B34141C0	José Manuel Estrada 2249	\N	B1636DDB	Olivos	Buenos Aires	Argentina	José maria estrugamou	1567481432	kari@nilus.org	\N	\N	\N	2017-11-30 17:49:39.460785	2017-11-30 17:49:39.460785	José Manuel Estrada 2249, B1636DDB Olivos, Buenos Aires, Argentina	Shippify	\N	{"data": {"address": "José Manuel Estrada 2249, B1636DDB Olivos, Buenos Aires, Argentina", "contact": {"name": "José maria estrugamou", "email": "kari@nilus.org", "phonenumber": "1567481432"}, "latitude": -34.5133, "longitude": -58.4847}, "fetched_at": "2017-11-30T14:49:39.460-03:00"}
54a1d9a5-5894-4e6a-b17d-aab2ff8de98c	\N	0101000020E6100000F4FDD478E9564EC02AA913D0447840C0	Bv. Avellaneda 853	\N	S2002	Rosario	Santa Fe	Argentina	Aislanpor	0341 4392743	jejimenez@gmail.com	\N	\N	\N	2017-11-30 17:49:43.166642	2017-11-30 17:49:43.166642	Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina	Shippify	\N	{"data": {"address": "Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina", "contact": {"name": "Aislanpor", "email": "jejimenez@gmail.com", "phonenumber": "0341 4392743"}, "latitude": -32.9396, "longitude": -60.679}, "fetched_at": "2017-11-30T14:49:43.166-03:00"}
3b2a2d3d-c7ac-40e9-80be-08f77f3f76d8	\N	0101000020E6100000FED478E926594EC0933A014D847D40C0	Comandos 602 4384	\N	\N	Rosario	Santa Fe	Argentina	Angela rosa de los santos	155093278	155093278@shippify.co	\N	\N	\N	2017-11-30 17:49:50.861616	2017-11-30 17:49:50.861616	Comandos 602 4384, Rosario, Santa Fe, Argentina	Shippify	\N	{"data": {"address": "Comandos 602 4384, Rosario, Santa Fe, Argentina", "contact": {"name": "Angela rosa de los santos", "email": "155093278@shippify.co", "phonenumber": "155093278"}, "latitude": -32.9806, "longitude": -60.6965}, "fetched_at": "2017-11-30T14:49:50.861-03:00"}
\.


--

--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	development	2017-11-30 17:48:45.23468	2017-11-30 17:48:45.23468
\.


--

--

COPY bank_accounts (id, bank_name, number, type, cbu, shipper_id, created_at, updated_at) FROM stdin;
\.


--

--

COPY deliveries (id, order_id, trip_id, amount, bonified_amount, origin_id, origin_gps_coordinates, destination_id, destination_gps_coordinates, status, created_at, updated_at, gateway, gateway_id, gateway_data) FROM stdin;
1	ce651f2d-fa26-4b0d-92e0-e68bc8763131	f48f9c47-3c1e-47e0-a53c-b43f7a43f304	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	assigned	2017-11-30 17:49:34.126198	2017-11-30 17:49:34.184549	Shippify	t-nilus-51	{"id": "t-nilus-51", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-11T12:00:00.000Z", "start": "2017-11-11T11:00:00.000Z"}}, "status": "assigned", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-11T13:00:00.000Z", "start": "2017-11-11T12:00:00.000Z"}}, "package": {"capacity": 1, "contents": [{"name": "Papas", "size": 1, "quantity": 1}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
2	7615c085-8636-4968-b3ab-48c716f01879	e1ddc12f-c01e-4ce8-9e9a-26bb3aa95a17	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	assigned	2017-11-30 17:49:35.177075	2017-11-30 17:49:35.191108	Shippify	t-nilus-52	{"id": "t-nilus-52", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-13T12:45:55.000Z", "start": "2017-11-13T11:45:55.000Z"}}, "status": "assigned", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-13T13:45:55.000Z", "start": "2017-11-13T12:45:55.000Z"}}, "package": {"capacity": 1, "contents": [{"name": "Papas", "size": 1, "quantity": 1}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
3	ea629886-5670-4138-9d09-fe448c0fbf13	c341d6a1-4bce-4230-bc62-d9c1eb68df76	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	fd58650b-5ab8-4c81-960e-4915160130e1	0101000020E61000002506819543534EC00D71AC8BDB7840C0	assigned	2017-11-30 17:49:36.189627	2017-11-30 17:49:36.201981	Shippify	t-nilus-53	{"id": "t-nilus-53", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-13T12:45:55.000Z", "start": "2017-11-13T11:45:55.000Z"}}, "status": "assigned", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Pablo", "email": "pablo@nilus.org", "phonenumber": "999"}, "location": {"address": "Rosario, Santa Fe Province, Argentina", "latitude": -32.9442, "longitude": -60.6505}, "timeWindow": {"end": "2017-11-13T13:45:55.000Z", "start": "2017-11-13T12:45:55.000Z"}}, "package": {"capacity": 1, "contents": [{"name": "Papas", "size": 1, "quantity": 1}]}, "receiver": {"name": "Pablo", "email": "pablo@nilus.org", "phonenumber": "999"}, "referenceId": null}
4	5b5acf70-2c6b-442a-a982-46f23955b522	a645b7ce-307f-458d-88a8-0ca568549e4e	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	completed	2017-11-30 17:49:37.192388	2017-11-30 17:49:37.208667	Shippify	t-nilus-54	{"id": "t-nilus-54", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-15T15:25:17.812Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-16T15:00:00.000Z", "start": "2017-11-16T14:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-15T15:25:44.819Z", "extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-16T16:00:00.000Z", "start": "2017-11-16T15:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "10 cajas de alimentos", "size": 3, "quantity": 10}, {"name": "1 heladerita con frescos", "size": 3, "quantity": 1}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
5	22ae43ac-a617-496d-9207-6e069952c494	27aa07e0-4b95-47a2-9076-a447a571a153	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	client_canceled	2017-11-30 17:49:38.248447	2017-11-30 17:49:38.262146	Shippify	t-nilus-55	{"id": "t-nilus-55", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-16T16:00:00.000Z", "start": "2017-11-16T15:00:00.000Z"}}, "status": "client_canceled", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-16T17:00:00.000Z", "start": "2017-11-16T16:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "10 cajas de alimentos no perecederos", "size": 3, "quantity": 10}, {"name": "1 heladerita de alimentos frescos", "size": 3, "quantity": 1}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
6	1543f014-952e-4b82-9b75-718f861f3d97	fb7ce04a-efc2-4df7-91a4-220077032f10	375.0000	\N	6755cdf1-203f-4bc5-9b06-5cf79dd4bd5e	0101000020E6100000E10B93A982394DC0462575029A5041C0	e8bec291-eced-4bf1-bc86-e95668f71beb	0101000020E6100000832F4CA60A3E4DC0B6847CD0B34141C0	broadcasting	2017-11-30 17:49:39.465102	2017-11-30 17:49:39.476289	Shippify	t-nilus-56	{"id": "t-nilus-56", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "1567481432"}, "location": {"address": "Malvinas Argentinas 456, C1406 CABA, Argentina", "latitude": -34.6297, "longitude": -58.4493}, "timeWindow": {"end": "2017-11-16T21:00:00.000Z", "start": "2017-11-16T20:00:00.000Z"}}, "status": "broadcasting", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "José maria estrugamou", "email": "kari@nilus.org", "phonenumber": "1567481432"}, "location": {"address": "José Manuel Estrada 2249, B1636DDB Olivos, Buenos Aires, Argentina", "latitude": -34.5133, "longitude": -58.4847}, "timeWindow": {"end": "2017-11-16T22:00:00.000Z", "start": "2017-11-16T21:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "10 cajas de alimentos", "size": 3, "quantity": 10}]}, "receiver": {"name": "José maria estrugamou", "email": "kari@nilus.org", "phonenumber": "1567481432"}, "referenceId": null}
7	8dbe1923-d0ce-4b8c-9a4c-017d0d18cbc5	1f2400d6-bfd7-4e47-a75b-aabdebf85bc5	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	client_canceled	2017-11-30 17:49:40.704937	2017-11-30 17:49:40.722482	Shippify	t-nilus-57	{"id": "t-nilus-57", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-15T22:00:00.000Z", "start": "2017-11-15T21:00:00.000Z"}}, "status": "client_canceled", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-15T23:00:00.000Z", "start": "2017-11-15T22:00:00.000Z"}}, "package": {"capacity": 5, "contents": [{"name": "1 caja de alimentos", "size": 3, "quantity": 1}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
8	8cff5f31-c2ad-415b-baf4-46db4c96c3c9	762fd09a-e6bb-40b7-99ad-c23efec7e789	375.0000	\N	54a1d9a5-5894-4e6a-b17d-aab2ff8de98c	0101000020E6100000F4FDD478E9564EC02AA913D0447840C0	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	client_canceled	2017-11-30 17:49:43.172801	2017-11-30 17:49:43.185675	Shippify	t-nilus-58	{"id": "t-nilus-58", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-16T14:40:21.285Z", "extras": [], "contact": {"name": "Aislanpor", "email": "jejimenez@gmail.com", "phonenumber": "0341 4392743"}, "location": {"address": "Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9396, "longitude": -60.679}, "timeWindow": {"end": "2017-11-16T18:00:00.000Z", "start": "2017-11-16T17:00:00.000Z"}}, "status": "client_canceled", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-16T15:22:26.122Z", "extras": [], "contact": {"name": "Karina campos", "email": "karinacamposrodriguez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-16T19:00:00.000Z", "start": "2017-11-16T18:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "10 heladeritas de telgopor", "size": 3, "quantity": 10}, {"name": "60 geles refrigerantes", "size": 1, "quantity": 1}]}, "receiver": {"name": "Karina campos", "email": "karinacamposrodriguez@gmail.com", "phonenumber": "5491167481432"}, "referenceId": null}
9	aa869cda-c94e-40e6-9955-d8f91639c855	d8973aab-9e40-4f93-ae18-ab2ffc07fbad	375.0000	\N	54a1d9a5-5894-4e6a-b17d-aab2ff8de98c	0101000020E6100000F4FDD478E9564EC02AA913D0447840C0	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	completed	2017-11-30 17:49:44.179554	2017-11-30 17:49:44.19245	Shippify	t-nilus-59	{"id": "t-nilus-59", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-16T17:16:38.217Z", "extras": [], "contact": {"name": "Aislanpor", "email": "jejimenez@gmail.com", "phonenumber": "0341 4392743"}, "location": {"address": "Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9396, "longitude": -60.679}, "timeWindow": {"end": "2017-11-16T18:00:00.000Z", "start": "2017-11-16T17:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-16T17:31:42.748Z", "extras": [], "contact": {"name": "Karina campos", "email": "karinacamposrodriguez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-16T19:00:00.000Z", "start": "2017-11-16T18:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "10 heladeras de telgopor", "size": 3, "quantity": 10}, {"name": "60 geles", "size": 1, "quantity": 1}]}, "receiver": {"name": "Karina campos", "email": "karinacamposrodriguez@gmail.com", "phonenumber": "5491167481432"}, "referenceId": null}
10	23a7aff4-4018-4037-9084-473e34c84a93	bba29b5e-af56-4e13-8a56-ebddcc35bfcc	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	completed	2017-11-30 17:49:46.496558	2017-11-30 17:49:46.510679	Shippify	t-nilus-60	{"id": "t-nilus-60", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-17T13:13:10.561Z", "extras": [], "contact": {"name": "Nicolàs", "email": "jejimenez@gmail.com", "phonenumber": "3412515656"}, "location": {"address": "Banco de Alimentos Rosario, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-17T14:00:00.000Z", "start": "2017-11-17T13:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-17T13:47:34.725Z", "extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-17T15:00:00.000Z", "start": "2017-11-17T14:00:00.000Z"}}, "package": {"capacity": 4, "contents": [{"name": "12 cajas de alimento no perecedero", "size": 3, "quantity": 11}, {"name": "9 cajas de refrigerados", "size": 3, "quantity": 9}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
11	2c43a842-104a-4a14-8270-a06c150a4e41	de95a9e2-99c3-4206-a16b-5a5eecfad423	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	975e51f6-c9bf-4ddc-86eb-0f8ab995b3fd	0101000020E6100000D34D621058514EC0022B8716D97E40C0	completed	2017-11-30 17:49:47.67851	2017-11-30 17:49:47.692318	Shippify	t-nilus-61	{"id": "t-nilus-61", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-21T13:05:30.897Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-21T14:00:00.000Z", "start": "2017-11-21T13:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-21T13:45:24.158Z", "extras": [], "contact": {"name": "Roxana mansilla - asociación civil alas para crecer", "email": "156936337@shippify.co", "phonenumber": "156936337"}, "location": {"address": "Medici 4620, S2001GKB Rosario, Santa Fe, Argentina", "latitude": -32.991, "longitude": -60.6355}, "timeWindow": {"end": "2017-11-21T15:00:00.000Z", "start": "2017-11-21T14:00:00.000Z"}}, "package": {"capacity": 4, "contents": [{"name": "Heladeritas refrigerados (Aprox.)", "size": 3, "quantity": 3}, {"name": "CAJA No perecederos", "size": 3, "quantity": 33}]}, "receiver": {"name": "Roxana mansilla - asociación civil alas para crecer", "email": "156936337@shippify.co", "phonenumber": "156936337"}, "referenceId": null}
12	d51565b0-8b22-4548-a8ca-6540ae9da3f2	3802c42c-24ec-4916-ba8e-4795e74cb464	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	da180da3-937f-492f-b99a-6d671834a610	0101000020E61000000000000000584EC0ECC039234A7B40C0	completed	2017-11-30 17:49:48.702289	2017-11-30 17:49:48.717634	Shippify	t-nilus-62	{"id": "t-nilus-62", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-23T11:26:15.733Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-23T12:00:00.000Z", "start": "2017-11-23T11:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-23T11:48:55.729Z", "extras": [], "contact": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "location": {"address": "Rueda 4265, Rosario, Santa Fe, Argentina", "latitude": -32.9632, "longitude": -60.6875}, "timeWindow": {"end": "2017-11-23T13:00:00.000Z", "start": "2017-11-23T12:00:00.000Z"}}, "package": {"capacity": 4, "contents": [{"name": "Bultos de alimentos no perecederos", "size": 3, "quantity": 42}, {"name": "Refrigerados", "size": 3, "quantity": 3}]}, "receiver": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "referenceId": null}
13	cd4c411b-018f-4f67-8991-5cb097f88b5b	cf3a82be-df03-4df4-b09f-8adda536e873	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	7f891cb3-ce32-45aa-bd9b-6d705f060ef7	0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0	completed	2017-11-30 17:49:49.828598	2017-11-30 17:49:49.843405	Shippify	t-nilus-63	{"id": "t-nilus-63", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-23T11:51:46.470Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-23T13:00:00.000Z", "start": "2017-11-23T12:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-23T12:21:03.640Z", "extras": [], "contact": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "location": {"address": "Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina", "latitude": -32.924, "longitude": -60.7061}, "timeWindow": {"end": "2017-11-23T14:00:00.000Z", "start": "2017-11-23T13:00:00.000Z"}}, "package": {"capacity": 5, "contents": [{"name": "Bultos de alimentos no perecederos", "size": 3, "quantity": 23}, {"name": "Bultos de alimentos refrigerados", "size": 3, "quantity": 65}]}, "receiver": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "referenceId": null}
14	5d434913-8064-4c5e-8c20-8de25100d798	ab4594d6-cda1-4439-87dc-b8207795f04d	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	3b2a2d3d-c7ac-40e9-80be-08f77f3f76d8	0101000020E6100000FED478E926594EC0933A014D847D40C0	completed	2017-11-30 17:49:50.869277	2017-11-30 17:49:50.884224	Shippify	t-nilus-64	{"id": "t-nilus-64", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-24T13:05:33.980Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-24T14:00:00.000Z", "start": "2017-11-24T13:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-24T13:31:23.722Z", "extras": [], "contact": {"name": "Angela rosa de los santos", "email": "155093278@shippify.co", "phonenumber": "155093278"}, "location": {"address": "Comandos 602 4384, Rosario, Santa Fe, Argentina", "latitude": -32.9806, "longitude": -60.6965}, "timeWindow": {"end": "2017-11-24T15:00:00.000Z", "start": "2017-11-24T14:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "Alimentos no perecederos", "size": 3, "quantity": 8}, {"name": "Heladerita", "size": 3, "quantity": 1}]}, "receiver": {"name": "Angela rosa de los santos", "email": "155093278@shippify.co", "phonenumber": "155093278"}, "referenceId": null}
15	6f3fae95-a4cc-4c46-991b-ea1ce8c4aa8b	cab81027-6488-4a06-9468-b8d1eb79474b	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	975e51f6-c9bf-4ddc-86eb-0f8ab995b3fd	0101000020E6100000D34D621058514EC0022B8716D97E40C0	completed	2017-11-30 17:49:51.977478	2017-11-30 17:49:51.99247	Shippify	t-nilus-65	{"id": "t-nilus-65", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-27T13:01:43.145Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-27T14:00:00.000Z", "start": "2017-11-27T13:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-27T15:04:34.106Z", "extras": [], "contact": {"name": "Roxana mansilla", "email": "156936337@shippify.co", "phonenumber": "156936337"}, "location": {"address": "Medici 4620, S2001GKB Rosario, Santa Fe, Argentina", "latitude": -32.991, "longitude": -60.6355}, "timeWindow": {"end": "2017-11-27T15:00:00.000Z", "start": "2017-11-27T14:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "Bultos de alimentos no perecederos", "size": 3, "quantity": 22}, {"name": "Heladeritas", "size": 3, "quantity": 1}]}, "receiver": {"name": "Roxana mansilla", "email": "156936337@shippify.co", "phonenumber": "156936337"}, "referenceId": null}
16	62082987-8a24-4a22-84bc-d81e7a7bb0a9	a4b8cff9-daa2-4f37-bb75-705a255c1da0	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	7f891cb3-ce32-45aa-bd9b-6d705f060ef7	0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0	completed	2017-11-30 17:49:53.005024	2017-11-30 17:49:53.022714	Shippify	t-nilus-66	{"id": "t-nilus-66", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-24T21:37:58.226Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-25T15:00:00.000Z", "start": "2017-11-25T14:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-24T21:38:08.868Z", "extras": [], "contact": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "location": {"address": "Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina", "latitude": -32.924, "longitude": -60.7061}, "timeWindow": {"end": "2017-11-25T16:00:00.000Z", "start": "2017-11-25T15:00:00.000Z"}}, "package": {"capacity": 1, "contents": [{"name": "alimentos", "size": 1, "quantity": 1}]}, "receiver": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "referenceId": null}
17	9c1147ab-17d3-48da-a293-ed7ea100d93a	2dc49d9a-accf-4107-b88d-781f8b44647e	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	7f891cb3-ce32-45aa-bd9b-6d705f060ef7	0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0	completed	2017-11-30 17:49:53.977421	2017-11-30 17:49:53.991195	Shippify	t-nilus-67	{"id": "t-nilus-67", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-24T21:40:20.706Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-25T17:00:00.000Z", "start": "2017-11-25T16:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "location": {"address": "Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina", "latitude": -32.924, "longitude": -60.7061}, "timeWindow": {"end": "2017-11-25T18:00:00.000Z", "start": "2017-11-25T17:00:00.000Z"}}, "package": {"capacity": 1, "contents": [{"name": "alimentos", "size": 1, "quantity": 1}]}, "receiver": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "referenceId": null}
18	788596d5-9152-4a6d-8e37-f3f4d673c6b1	376bc458-bc3f-44eb-a8f7-87addce00143	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	da180da3-937f-492f-b99a-6d671834a610	0101000020E61000000000000000584EC0ECC039234A7B40C0	completed	2017-11-30 17:49:54.925018	2017-11-30 17:49:54.939747	Shippify	t-nilus-68	{"id": "t-nilus-68", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-28T12:06:21.412Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-28T13:00:00.000Z", "start": "2017-11-28T12:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-28T12:38:10.553Z", "extras": [], "contact": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "location": {"address": "Rueda 4265, Rosario, Santa Fe, Argentina", "latitude": -32.9632, "longitude": -60.6875}, "timeWindow": {"end": "2017-11-28T14:00:00.000Z", "start": "2017-11-28T13:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "Bultos alimentos no perecederos", "size": 3, "quantity": 16}, {"name": "Heladeritas", "size": 3, "quantity": 2}]}, "receiver": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "referenceId": null}
19	4810ff41-7666-4124-bbc8-39e119af672b	1505f31b-5c68-49ae-a0eb-4696478d8932	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	7f891cb3-ce32-45aa-bd9b-6d705f060ef7	0101000020E610000051DA1B7C615A4EC083C0CAA1457640C0	completed	2017-11-30 17:49:55.972982	2017-11-30 17:49:55.987818	Shippify	t-nilus-69	{"id": "t-nilus-69", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-30T11:48:51.395Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-30T12:00:00.000Z", "start": "2017-11-30T11:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-30T12:21:11.441Z", "extras": [], "contact": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "location": {"address": "Gorriti 6080, S2007BQT Rosario, Santa Fe, Argentina", "latitude": -32.924, "longitude": -60.7061}, "timeWindow": {"end": "2017-11-30T13:00:00.000Z", "start": "2017-11-30T12:00:00.000Z"}}, "package": {"capacity": 5, "contents": [{"name": "Bultos de alimentos no perecederos", "size": 3, "quantity": 102}, {"name": "Bultos de alimentos refrigerados", "size": 3, "quantity": 104}]}, "receiver": {"name": "Mirta barrios", "email": "155484625@shippify.co", "phonenumber": "155484625"}, "referenceId": null}
20	86726469-9191-4589-a7cb-4f220bb99643	c03b5ea8-3f68-4552-867f-2dcf62f1a911	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	8ea6c4fb-4f39-4905-a133-f132909e5bde	0101000020E6100000789CA223B9544EC0DAACFA5C6D7D40C0	completed	2017-11-30 17:49:57.014639	2017-11-30 17:49:57.030077	Shippify	t-nilus-70	{"id": "t-nilus-70", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"doneAt": "2017-11-30T12:30:57.964Z", "extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-30T13:00:00.000Z", "start": "2017-11-30T12:00:00.000Z"}}, "status": "completed", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"doneAt": "2017-11-30T12:31:04.813Z", "extras": [], "contact": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "location": {"address": "Pres. Quintana 2173, S2001ARQ Rosario, Santa Fe, Argentina", "latitude": -32.9799, "longitude": -60.6619}, "timeWindow": {"end": "2017-11-30T14:00:00.000Z", "start": "2017-11-30T13:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "Bultos de alimentos no perecederos", "size": 3, "quantity": 21}, {"name": "Heladeritas", "size": 1, "quantity": 2}]}, "receiver": {"name": "Isabel berizzo", "email": "156179787@shippify.co", "phonenumber": "156179787"}, "referenceId": null}
21	f4f2dc82-1ff9-4f1e-8801-3544dd464f9e	1eea1975-804c-46f1-aa63-19563499a289	375.0000	\N	6d52cf7d-ffa5-444e-bd57-b709ebf588f9	0101000020E61000009CA223B9FC574EC0014D840D4F7740C0	da180da3-937f-492f-b99a-6d671834a610	0101000020E61000000000000000584EC0ECC039234A7B40C0	processing	2017-11-30 17:49:58.00845	2017-11-30 17:49:58.021668	Shippify	t-nilus-71	{"id": "t-nilus-71", "fare": {"cash": 0, "service": 375, "delivery": 300, "currencyCode": "ARS"}, "pickup": {"extras": [], "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "phonenumber": "5491167481432"}, "location": {"address": "Rosario Food Bank, Carriego 360, S2002 Rosario, Santa Fe, Argentina", "latitude": -32.9321, "longitude": -60.6874}, "timeWindow": {"end": "2017-11-30T21:00:00.000Z", "start": "2017-11-30T20:00:00.000Z"}}, "status": "processing", "company": {"id": 618, "name": "Nilus"}, "dropoff": {"extras": [], "contact": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "location": {"address": "Rueda 4265, Rosario, Santa Fe, Argentina", "latitude": -32.9632, "longitude": -60.6875}, "timeWindow": {"end": "2017-11-30T22:00:00.000Z", "start": "2017-11-30T21:00:00.000Z"}}, "package": {"capacity": 3, "contents": [{"name": "bultos de no perecederos = 150 kg", "size": 3, "quantity": 3}]}, "receiver": {"name": "Sandra arce", "email": "153480194@shippify.co", "phonenumber": "153480194"}, "referenceId": null}
\.


--

--

COPY institutions (id, name, legal_name, uid_type, uid, type, created_at, updated_at) FROM stdin;
07238384-5715-43e8-b3ec-654b7bb40876	213 - Solcito	\N	CUIT	\N	Institutions::Organization	2017-11-30 17:49:21.076505	2017-11-30 17:49:21.076505
de2166cc-3bea-467e-a4e6-c15f4ec5bcd3	223 - Asociación Civil Alas Para Crecer	\N	CUIT	\N	Institutions::Organization	2017-11-30 17:49:21.083966	2017-11-30 17:49:21.083966
2fd23688-d680-4730-ba7e-3433c02f375a	97 - San Cayetano	\N	CUIT	\N	Institutions::Organization	2017-11-30 17:49:21.088096	2017-11-30 17:49:21.088096
580921ef-6526-4e5b-8f85-5a385b024d64	Asociación Civil Evita Sol Naciente	\N	CUIT	\N	Institutions::Organization	2017-11-30 17:49:21.09195	2017-11-30 17:49:21.09195
596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	BAR	\N	CUIT	\N	Institutions::Organization	2017-11-30 17:49:21.095964	2017-11-30 17:49:21.095964
\.


--

--

COPY orders (id, giver_id, receiver_id, expiration, amount, bonified_amount, created_at, updated_at) FROM stdin;
ce651f2d-fa26-4b0d-92e0-e68bc8763131	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:34.096954	2017-11-30 17:49:34.096954
7615c085-8636-4968-b3ab-48c716f01879	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:35.173573	2017-11-30 17:49:35.173573
ea629886-5670-4138-9d09-fe448c0fbf13	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:36.186839	2017-11-30 17:49:36.186839
5b5acf70-2c6b-442a-a982-46f23955b522	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:37.189081	2017-11-30 17:49:37.189081
22ae43ac-a617-496d-9207-6e069952c494	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:38.245263	2017-11-30 17:49:38.245263
1543f014-952e-4b82-9b75-718f861f3d97	\N	\N	\N	\N	\N	2017-11-30 17:49:39.462464	2017-11-30 17:49:39.462464
8dbe1923-d0ce-4b8c-9a4c-017d0d18cbc5	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:40.701603	2017-11-30 17:49:40.701603
8cff5f31-c2ad-415b-baf4-46db4c96c3c9	\N	\N	\N	\N	\N	2017-11-30 17:49:43.169744	2017-11-30 17:49:43.169744
aa869cda-c94e-40e6-9955-d8f91639c855	\N	\N	\N	\N	\N	2017-11-30 17:49:44.176357	2017-11-30 17:49:44.176357
23a7aff4-4018-4037-9084-473e34c84a93	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:46.493542	2017-11-30 17:49:46.493542
2c43a842-104a-4a14-8270-a06c150a4e41	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:47.674955	2017-11-30 17:49:47.674955
d51565b0-8b22-4548-a8ca-6540ae9da3f2	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:48.699099	2017-11-30 17:49:48.699099
cd4c411b-018f-4f67-8991-5cb097f88b5b	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:49.82555	2017-11-30 17:49:49.82555
5d434913-8064-4c5e-8c20-8de25100d798	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:50.866274	2017-11-30 17:49:50.866274
6f3fae95-a4cc-4c46-991b-ea1ce8c4aa8b	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:51.974395	2017-11-30 17:49:51.974395
62082987-8a24-4a22-84bc-d81e7a7bb0a9	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:53.001765	2017-11-30 17:49:53.001765
9c1147ab-17d3-48da-a293-ed7ea100d93a	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:53.974258	2017-11-30 17:49:53.974258
788596d5-9152-4a6d-8e37-f3f4d673c6b1	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:54.922207	2017-11-30 17:49:54.922207
4810ff41-7666-4124-bbc8-39e119af672b	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:55.969937	2017-11-30 17:49:55.969937
86726469-9191-4589-a7cb-4f220bb99643	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:57.011417	2017-11-30 17:49:57.011417
f4f2dc82-1ff9-4f1e-8801-3544dd464f9e	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	596318c5-6bd5-4d54-8fb1-6a7f5ad8ff09	\N	\N	\N	2017-11-30 17:49:58.005191	2017-11-30 17:49:58.005191
\.


--

--

COPY packages (id, delivery_id, weight, volume, cooling, description, attachment_id, created_at, updated_at, quantity, fragile) FROM stdin;
1	1	\N	\N	f	Papas	\N	2017-11-30 17:49:34.146137	2017-11-30 17:49:34.146137	1	f
2	2	\N	\N	f	Papas	\N	2017-11-30 17:49:35.179186	2017-11-30 17:49:35.179186	1	f
3	3	\N	\N	f	Papas	\N	2017-11-30 17:49:36.191403	2017-11-30 17:49:36.191403	1	f
4	4	\N	\N	f	10 cajas de alimentos	\N	2017-11-30 17:49:37.194432	2017-11-30 17:49:37.194432	10	f
5	4	\N	\N	f	1 heladerita con frescos	\N	2017-11-30 17:49:37.195675	2017-11-30 17:49:37.195675	1	f
6	5	\N	\N	f	10 cajas de alimentos no perecederos	\N	2017-11-30 17:49:38.25038	2017-11-30 17:49:38.25038	10	f
7	5	\N	\N	f	1 heladerita de alimentos frescos	\N	2017-11-30 17:49:38.251611	2017-11-30 17:49:38.251611	1	f
8	6	\N	\N	f	10 cajas de alimentos	\N	2017-11-30 17:49:39.466851	2017-11-30 17:49:39.466851	10	f
9	7	\N	\N	f	1 caja de alimentos	\N	2017-11-30 17:49:40.711418	2017-11-30 17:49:40.711418	1	f
10	8	\N	\N	f	10 heladeritas de telgopor	\N	2017-11-30 17:49:43.175323	2017-11-30 17:49:43.175323	10	f
11	8	\N	\N	f	60 geles refrigerantes	\N	2017-11-30 17:49:43.17648	2017-11-30 17:49:43.17648	1	f
12	9	\N	\N	f	10 heladeras de telgopor	\N	2017-11-30 17:49:44.181466	2017-11-30 17:49:44.181466	10	f
13	9	\N	\N	f	60 geles	\N	2017-11-30 17:49:44.182612	2017-11-30 17:49:44.182612	1	f
14	10	\N	\N	f	12 cajas de alimento no perecedero	\N	2017-11-30 17:49:46.498516	2017-11-30 17:49:46.498516	11	f
15	10	\N	\N	f	9 cajas de refrigerados	\N	2017-11-30 17:49:46.499627	2017-11-30 17:49:46.499627	9	f
16	11	\N	\N	f	Heladeritas refrigerados (Aprox.)	\N	2017-11-30 17:49:47.680524	2017-11-30 17:49:47.680524	3	f
17	11	\N	\N	f	CAJA No perecederos	\N	2017-11-30 17:49:47.681621	2017-11-30 17:49:47.681621	33	f
18	12	\N	\N	f	Bultos de alimentos no perecederos	\N	2017-11-30 17:49:48.704382	2017-11-30 17:49:48.704382	42	f
19	12	\N	\N	f	Refrigerados	\N	2017-11-30 17:49:48.705862	2017-11-30 17:49:48.705862	3	f
20	13	\N	\N	f	Bultos de alimentos no perecederos	\N	2017-11-30 17:49:49.830759	2017-11-30 17:49:49.830759	23	f
21	13	\N	\N	f	Bultos de alimentos refrigerados	\N	2017-11-30 17:49:49.832097	2017-11-30 17:49:49.832097	65	f
22	14	\N	\N	f	Alimentos no perecederos	\N	2017-11-30 17:49:50.871281	2017-11-30 17:49:50.871281	8	f
23	14	\N	\N	f	Heladerita	\N	2017-11-30 17:49:50.872408	2017-11-30 17:49:50.872408	1	f
24	15	\N	\N	f	Bultos de alimentos no perecederos	\N	2017-11-30 17:49:51.979327	2017-11-30 17:49:51.979327	22	f
25	15	\N	\N	f	Heladeritas	\N	2017-11-30 17:49:51.980412	2017-11-30 17:49:51.980412	1	f
26	16	\N	\N	f	alimentos	\N	2017-11-30 17:49:53.010861	2017-11-30 17:49:53.010861	1	f
27	17	\N	\N	f	alimentos	\N	2017-11-30 17:49:53.979951	2017-11-30 17:49:53.979951	1	f
28	18	\N	\N	f	Bultos alimentos no perecederos	\N	2017-11-30 17:49:54.926995	2017-11-30 17:49:54.926995	16	f
29	18	\N	\N	f	Heladeritas	\N	2017-11-30 17:49:54.92818	2017-11-30 17:49:54.92818	2	f
30	19	\N	\N	f	Bultos de alimentos no perecederos	\N	2017-11-30 17:49:55.974977	2017-11-30 17:49:55.974977	102	f
31	19	\N	\N	f	Bultos de alimentos refrigerados	\N	2017-11-30 17:49:55.976155	2017-11-30 17:49:55.976155	104	f
32	20	\N	\N	f	Bultos de alimentos no perecederos	\N	2017-11-30 17:49:57.016712	2017-11-30 17:49:57.016712	21	f
33	20	\N	\N	f	Heladeritas	\N	2017-11-30 17:49:57.017892	2017-11-30 17:49:57.017892	2	f
34	21	\N	\N	f	bultos de no perecederos = 150 kg	\N	2017-11-30 17:49:58.010527	2017-11-30 17:49:58.010527	3	f
\.


--

--

COPY profiles (id, first_name, last_name, user_id, preferences, created_at, updated_at) FROM stdin;
\.


--

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
\.


--

--

COPY shippers (id, first_name, last_name, gender, birth_date, email, phone_num, photo, active, verified, verified_at, national_ids, gateway, gateway_id, data, minimum_requirements, requirements, created_at, updated_at) FROM stdin;
8b714a02-4ba2-4747-ae22-b145a3786d7e	Adrian Armando	Heredia	\N	\N	and33hhaa@hotmail.com	+543415083870	\N	t	t	\N	{}	Shippify	29897	{":data": {"id": 29897, "city": "Rosario", "name": "Adrian Armando Heredia ", "type": 2, "email": "and33hhaa@hotmail.com", "phone": "+543415083870", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "and33hhaa@hotmail.com", "doc_id": null, "mobile": "+543415083870", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-11T20:02:07.000Z", "first_name": "Adrian Armando Heredia", "shipper_id": 29897, "vehicle_id": 8750, "company_name": "Nilus", "vehicle_type": "FORD F 100", "license_plate": "WUY733", "vehicle_model": "1977", "verify_status": 0, "vehicle_creation": "2017-10-12T16:42:26.000Z"}, ":fetched_at": {"^t": 1512064149.549}}	{}	{}	2017-11-30 17:49:09.550521	2017-11-30 17:49:09.550521
d07f8aa6-c0fa-44ed-bc71-d59dbce6c6bd	Ady	\N	\N	\N	adybeitler@gmail.com	+5491128947916	\N	t	t	\N	{}	Shippify	22168	{":data": {"id": 22168, "city": "Buenos Aires", "name": "Ady ", "type": 1, "email": "adybeitler@gmail.com", "phone": "+5491128947916", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "adybeitler@gmail.com", "doc_id": null, "mobile": "+5491128947916", "city_id": 9, "capacity": 3, "city_name": "Buenos Aires", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-06-08T09:59:43.000Z", "first_name": "Ady", "shipper_id": 22168, "vehicle_id": 6368, "company_name": "Nilus", "vehicle_type": "carro", "license_plate": "undefined", "vehicle_model": "carro", "verify_status": 0, "vehicle_creation": "2017-06-08T17:42:55.000Z"}, ":fetched_at": {"^t": 1512064149.805}}	{}	{}	2017-11-30 17:49:09.805968	2017-11-30 17:49:09.805968
1d6fdb6a-84af-4ce4-8644-95d0199c6539	Agustin	Cavi	\N	\N	agustin@donaronline.org	+5491130511002	\N	t	t	\N	{}	Shippify	21146	{":data": {"id": 21146, "city": "Buenos Aires", "name": "Agustin Cavi", "type": 1, "email": "agustin@donaronline.org", "phone": "+5491130511002", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "agustin@donaronline.org", "doc_id": null, "mobile": "+5491130511002", "city_id": 9, "capacity": 3, "city_name": "Buenos Aires", "last_name": "Cavi", "status_id": 3, "company_id": 618, "created_dt": "2017-05-23T12:51:20.000Z", "first_name": "Agustin", "shipper_id": 21146, "vehicle_id": null, "company_name": "Nilus", "vehicle_type": null, "license_plate": null, "vehicle_model": null, "verify_status": 0, "vehicle_creation": null}, ":fetched_at": {"^t": 1512064150.017}}	{}	{}	2017-11-30 17:49:10.017674	2017-11-30 17:49:10.017674
ebadec9c-cfdf-455b-8934-09b016649b9f	Cesar Sebastian	Gonzalez	\N	\N	sebacesar14@gmail.com	+543416137735	\N	t	t	\N	{}	Shippify	30482	{":data": {"id": 30482, "city": "Rosario", "name": "Cesar Sebastian Gonzalez ", "type": 2, "email": "sebacesar14@gmail.com", "phone": "+543416137735", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "sebacesar14@gmail.com", "doc_id": null, "mobile": "+543416137735", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-19T21:55:00.000Z", "first_name": "Cesar Sebastian Gonzalez", "shipper_id": 30482, "vehicle_id": 9142, "company_name": "Nilus", "vehicle_type": "Pick up Chevrolet S10 2.8 TDI STD 4x2 ca", "license_plate": "FKC634", "vehicle_model": "2006", "verify_status": 0, "vehicle_creation": "2017-10-25T16:24:13.000Z"}, ":fetched_at": {"^t": 1512064150.285}}	{}	{}	2017-11-30 17:49:10.285864	2017-11-30 17:49:10.285864
8945365e-b3e4-4575-80f1-e2fc57a6197d	Irene	Berardo	\N	\N	irene.berardo@gmail.com	+5491162560066	\N	t	t	\N	{}	Shippify	29945	{":data": {"id": 29945, "city": "Rosario", "name": "Irene Berardo ", "type": 1, "email": "irene.berardo@gmail.com", "phone": "+5491162560066", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "irene.berardo@gmail.com", "doc_id": null, "mobile": "+5491162560066", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-12T16:18:51.000Z", "first_name": "Irene Berardo", "shipper_id": 29945, "vehicle_id": 8840, "company_name": "Nilus", "vehicle_type": "", "license_plate": "", "vehicle_model": "", "verify_status": 0, "vehicle_creation": "2017-10-17T15:51:08.000Z"}, ":fetched_at": {"^t": 1512064150.497}}	{}	{}	2017-11-30 17:49:10.497672	2017-11-30 17:49:10.497672
7cc00e49-c481-4516-92a0-8046d8a992fd	July	Jimenez	\N	\N	jejimenez@gmail.com	+54911	\N	t	t	\N	{}	Shippify	15880	{":data": {"id": 15880, "city": "Washington DC", "name": "July Jimenez ", "type": 2, "email": "jejimenez@gmail.com", "phone": "+54911", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "jejimenez@gmail.com", "doc_id": null, "mobile": "+54911", "city_id": 17, "capacity": 3, "city_name": "Washington DC", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-01-31T13:33:26.000Z", "first_name": "July Jimenez", "shipper_id": 15880, "vehicle_id": 4177, "company_name": "Nilus", "vehicle_type": "Test Type", "license_plate": "12345123", "vehicle_model": "Test Model", "verify_status": 0, "vehicle_creation": "2017-02-02T17:35:58.000Z"}, ":fetched_at": {"^t": 1512064150.883}}	{}	{}	2017-11-30 17:49:10.884147	2017-11-30 17:49:10.884147
841c13b0-083e-4c7f-a623-6e23abd90454	Karen	Serfaty	\N	\N	keserfaty@gmail.com	+541136266811	\N	t	t	\N	{}	Shippify	27531	{":data": {"id": 27531, "city": "Rosario", "name": "Karen Serfaty ", "type": 2, "email": "keserfaty@gmail.com", "phone": "+541136266811", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "keserfaty@gmail.com", "doc_id": null, "mobile": "+541136266811", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-09-07T10:55:30.000Z", "first_name": "Karen Serfaty", "shipper_id": 27531, "vehicle_id": 8748, "company_name": "Nilus", "vehicle_type": "-", "license_plate": "-", "vehicle_model": "-", "verify_status": 0, "vehicle_creation": "2017-10-12T12:12:23.000Z"}, ":fetched_at": {"^t": 1512064151.098}}	{}	{}	2017-11-30 17:49:11.099372	2017-11-30 17:49:11.099372
3089fc3f-5d9c-43bf-a8d8-63d1b84c5c2c	Karina	\N	\N	\N	karinacamposrodriguez@gmail.com	+5491167481432	\N	t	t	\N	{}	Shippify	22596	{":data": {"id": 22596, "city": "Rosario", "name": "Karina ", "type": 2, "email": "karinacamposrodriguez@gmail.com", "phone": "+5491167481432", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "karinacamposrodriguez@gmail.com", "doc_id": null, "mobile": "+5491167481432", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-06-16T19:38:16.000Z", "first_name": "Karina", "shipper_id": 22596, "vehicle_id": 8749, "company_name": "Nilus", "vehicle_type": "-", "license_plate": "-", "vehicle_model": "-", "verify_status": 0, "vehicle_creation": "2017-10-12T15:20:17.000Z"}, ":fetched_at": {"^t": 1512064151.314}}	{}	{}	2017-11-30 17:49:11.314859	2017-11-30 17:49:11.314859
7dd811d0-00c0-4116-912b-4a35b5685a65	Mario	\N	\N	\N	mario@winguweb.org	+5491157315577	\N	t	f	\N	{}	Shippify	19732	{":data": {"id": 19732, "city": "Buenos Aires", "name": "Mario ", "type": 1, "email": "mario@winguweb.org", "phone": "+5491157315577", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 0}, ":details": {"email": "mario@winguweb.org", "doc_id": null, "mobile": "+5491157315577", "city_id": 9, "capacity": 3, "city_name": "Buenos Aires", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-04-26T10:32:00.000Z", "first_name": "Mario", "shipper_id": 19732, "vehicle_id": 6367, "company_name": "Nilus", "vehicle_type": "carro", "license_plate": "undefined", "vehicle_model": "carro", "verify_status": 0, "vehicle_creation": "2017-06-08T17:42:26.000Z"}, ":fetched_at": {"^t": 1512064151.820}}	{}	{}	2017-11-30 17:49:11.821949	2017-11-30 17:49:11.821949
4685397e-d7fb-43fc-8532-673e39e03c5f	Pablo	\N	\N	\N	pfibanez@gmail.com	+59899227275	\N	t	t	\N	{}	Shippify	25426	{":data": {"id": 25426, "city": "Rosario", "name": "Pablo ", "type": 1, "email": "pfibanez@gmail.com", "phone": "+59899227275", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "pfibanez@gmail.com", "doc_id": null, "mobile": "+59899227275", "city_id": 20, "capacity": 1, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-08-10T03:17:20.000Z", "first_name": "Pablo", "shipper_id": 25426, "vehicle_id": null, "company_name": "Nilus", "vehicle_type": null, "license_plate": null, "vehicle_model": null, "verify_status": 0, "vehicle_creation": null}, ":fetched_at": {"^t": 1512064152.037}}	{}	{}	2017-11-30 17:49:12.037687	2017-11-30 17:49:12.037687
7862d386-3ed8-4613-9d20-fb7eac91b02d	Romina Paula	Bodas	\N	\N	romy449@hotmail.com	+543413565301	\N	t	t	\N	{"dni": "28762396"}	Shippify	30473	{":data": {"id": 30473, "city": "Rosario", "name": "Romina Paula Bodas ", "type": 2, "email": "romy449@hotmail.com", "phone": "+543413565301", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "romy449@hotmail.com", "doc_id": "28762396", "mobile": "+543413565301", "city_id": 20, "capacity": 4, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-19T20:36:57.000Z", "first_name": "Romina Paula Bodas", "shipper_id": 30473, "vehicle_id": 9037, "company_name": "Nilus", "vehicle_type": "Kangoo confort 1.6 5A CD SVT 600 K", "license_plate": "JXT242", "vehicle_model": "2011", "verify_status": 0, "vehicle_creation": "2017-10-19T22:07:58.000Z"}, ":fetched_at": {"^t": 1512064152.253}}	{}	{}	2017-11-30 17:49:12.2533	2017-11-30 17:49:12.2533
89a2dfbc-7d85-403c-8b96-e591e5e5cc86	Ruben Di	Domenico	\N	\N	rcelano10@gmail.com	+543416422636	\N	f	t	\N	{}	Shippify	30819	{":data": {"id": 30819, "city": "Rosario", "name": "Ruben Di Domenico ", "type": 2, "email": "rcelano10@gmail.com", "phone": "+543416422636", "status": 1, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "rcelano10@gmail.com", "doc_id": null, "mobile": "+543416422636", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 1, "company_id": 618, "created_dt": "2017-10-24T14:31:27.000Z", "first_name": "Ruben Di Domenico", "shipper_id": 30819, "vehicle_id": 9094, "company_name": "Nilus", "vehicle_type": "", "license_plate": "", "vehicle_model": "", "verify_status": 0, "vehicle_creation": "2017-10-24T14:47:19.000Z"}, ":fetched_at": {"^t": 1512064152.739}}	{}	{}	2017-11-30 17:49:12.740224	2017-11-30 17:49:12.740224
6bfc6425-e00c-4ded-bc0a-fb3a3abd05e0	Santiago	\N	\N	\N	santiago.a.ferrari@gmail.com	+13126052145	\N	t	f	\N	{}	Shippify	16018	{":data": {"id": 16018, "city": "Washington DC", "name": "Santiago ", "type": 1, "email": "santiago.a.ferrari@gmail.com", "phone": "+13126052145", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 0}, ":details": {"email": "santiago.a.ferrari@gmail.com", "doc_id": null, "mobile": "+13126052145", "city_id": 17, "capacity": 3, "city_name": "Washington DC", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-02-03T00:37:36.000Z", "first_name": "Santiago", "shipper_id": 16018, "vehicle_id": null, "company_name": "Nilus", "vehicle_type": null, "license_plate": null, "vehicle_model": null, "verify_status": 0, "vehicle_creation": null}, ":fetched_at": {"^t": 1512064153.047}}	{}	{}	2017-11-30 17:49:13.047451	2017-11-30 17:49:13.047451
6701166a-f5bc-4b62-bd66-29c810a4425c	Walter Di	Pietro	\N	\N	walterdipietro@yahoo.com.ar	+543412128725	\N	t	t	\N	{"dni": "33.527.012"}	Shippify	29968	{":data": {"id": 29968, "city": "Rosario", "name": "Walter Di Pietro ", "type": 2, "email": "walterdipietro@yahoo.com.ar", "phone": "+543412128725", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "walterdipietro@yahoo.com.ar", "doc_id": "33.527.012", "mobile": "+543412128725", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-12T21:25:40.000Z", "first_name": "Walter Di Pietro", "shipper_id": 29968, "vehicle_id": 9030, "company_name": "Nilus", "vehicle_type": "Chevrolet Pick up C-20 custom", "license_plate": "TZD762", "vehicle_model": "1993", "verify_status": 0, "vehicle_creation": "2017-10-19T18:59:21.000Z"}, ":fetched_at": {"^t": 1512064153.260}}	{}	{}	2017-11-30 17:49:13.261103	2017-11-30 17:49:13.261103
5f5a02ea-9bc8-4d62-a18a-e6abf04c67c9	Yoana María	Rodríguez	\N	\N	yoa4a0@gmail.com	+543416578520	\N	t	t	\N	{"dni": "35.588.093"}	Shippify	29927	{":data": {"id": 29927, "city": "Rosario", "name": "Yoana María Rodríguez ", "type": 2, "email": "yoa4a0@gmail.com", "phone": "+543416578520", "status": 3, "recordsfiltered": 15, "is_documentation_verified": 1}, ":details": {"email": "yoa4a0@gmail.com", "doc_id": "35.588.093", "mobile": "+543416578520", "city_id": 20, "capacity": 5, "city_name": "Rosario", "last_name": "", "status_id": 3, "company_id": 618, "created_dt": "2017-10-12T04:46:37.000Z", "first_name": "Yoana María Rodríguez", "shipper_id": 29927, "vehicle_id": 9098, "company_name": "Nilus", "vehicle_type": "Peugeot Partner confort HDI 1.6", "license_plate": "LMQ359", "vehicle_model": "2012", "verify_status": 0, "vehicle_creation": "2017-10-24T17:23:21.000Z"}, ":fetched_at": {"^t": 1512064153.475}}	{}	{}	2017-11-30 17:49:13.475765	2017-11-30 17:49:13.475765
\.


--

--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--

--

COPY trips (id, shipper_id, status, comments, amount, schedule_at, pickups, dropoffs, gateway, gateway_id, gateway_data, created_at, updated_at) FROM stdin;
f48f9c47-3c1e-47e0-a53c-b43f7a43f304	4685397e-d7fb-43fc-8532-673e39e03c5f	broadcasting	\N	375.0000	2017-11-11 11:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 1}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 1}]	Shippify	t-nilus-51	{"id": "t-nilus-51", "city": {"id": "20", "name": "Rosario"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nilus-51", "activityType": "pickup"}, {"deliveryId": "t-nilus-51", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-small"}	2017-11-30 17:49:34.181065	2017-11-30 17:49:34.181065
e1ddc12f-c01e-4ce8-9e9a-26bb3aa95a17	4685397e-d7fb-43fc-8532-673e39e03c5f	broadcasting	\N	375.0000	2017-11-13 11:45:55	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 2}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 2}]	Shippify	t-nilus-52	{"id": "t-nilus-52", "city": {"id": "20", "name": "Rosario"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nilus-52", "activityType": "pickup"}, {"deliveryId": "t-nilus-52", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-small"}	2017-11-30 17:49:35.188995	2017-11-30 17:49:35.188995
c341d6a1-4bce-4230-bc62-d9c1eb68df76	4685397e-d7fb-43fc-8532-673e39e03c5f	broadcasting	\N	375.0000	2017-11-13 11:45:55	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 3}]	[{"notes": null, "place": "Rosario, Santa Fe Province, Argentina", "latlng": "-32.9442, -60.6505", "address": {"id": "fd58650b-5ab8-4c81-960e-4915160130e1", "city": "Rosario", "state": "Santa Fe Province", "country": "Argentina", "street_1": null, "street_2": null, "zip_code": null, "telephone": null}, "contact": {"name": "Pablo", "email": "pablo@nilus.org", "cellphone": "999"}, "open_hours": null, "delivery_id": 3}]	Shippify	t-nilus-53	{"id": "t-nilus-53", "city": {"id": "20", "name": "Rosario"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nilus-53", "activityType": "pickup"}, {"deliveryId": "t-nilus-53", "activityType": "dropoff"}], "distances": [4.2], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-small"}	2017-11-30 17:49:36.199685	2017-11-30 17:49:36.199685
a645b7ce-307f-458d-88a8-0ca568549e4e	3089fc3f-5d9c-43bf-a8d8-63d1b84c5c2c	completed	\N	375.0000	2017-11-16 14:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 4}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 4}]	Shippify	t-nilus-54	{"id": "t-nilus-54", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-54", "activityType": "pickup"}, {"deliveryId": "t-nilus-54", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:37.205037	2017-11-30 17:49:37.205037
27aa07e0-4b95-47a2-9076-a447a571a153	\N	canceled	\N	375.0000	2017-11-16 15:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 5}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 5}]	Shippify	t-nilus-55	{"id": "t-nilus-55", "city": {"id": "20", "name": "Rosario"}, "status": "canceled", "stepIds": [{"deliveryId": "t-nilus-55", "activityType": "pickup"}, {"deliveryId": "t-nilus-55", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:38.259997	2017-11-30 17:49:38.259997
fb7ce04a-efc2-4df7-91a4-220077032f10	\N	broadcasting	\N	375.0000	2017-11-16 20:00:00	[{"notes": null, "place": "Malvinas Argentinas 456, C1406 CABA, Argentina", "latlng": "-34.6297, -58.4493", "address": {"id": "6755cdf1-203f-4bc5-9b06-5cf79dd4bd5e", "city": "Argentinas 456", "state": "C1406 CABA", "country": "Argentina", "street_1": null, "street_2": null, "zip_code": "Malvinas", "telephone": null}, "contact": {"name": "Karina campos", "email": "jejimenez@gmail.com", "cellphone": "1567481432"}, "open_hours": null, "delivery_id": 6}]	[{"notes": null, "place": "José Manuel Estrada 2249, B1636DDB Olivos, Buenos Aires, Argentina", "latlng": "-34.5133, -58.4847", "address": {"id": "e8bec291-eced-4bf1-bc86-e95668f71beb", "city": "Olivos", "state": "Buenos Aires", "country": "Argentina", "street_1": "José Manuel Estrada 2249", "street_2": null, "zip_code": "B1636DDB", "telephone": null}, "contact": {"name": "José maria estrugamou", "email": "kari@nilus.org", "cellphone": "1567481432"}, "open_hours": null, "delivery_id": 6}]	Shippify	t-nilus-56	{"id": "t-nilus-56", "city": {"id": "9", "name": "Buenos Aires"}, "status": "broadcasting", "stepIds": [{"deliveryId": "t-nilus-56", "activityType": "pickup"}, {"deliveryId": "t-nilus-56", "activityType": "dropoff"}], "distances": [15.8], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:39.47374	2017-11-30 17:49:39.47374
1f2400d6-bfd7-4e47-a75b-aabdebf85bc5	\N	canceled	\N	375.0000	2017-11-15 21:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 7}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 7}]	Shippify	t-nilus-57	{"id": "t-nilus-57", "city": {"id": "20", "name": "Rosario"}, "status": "canceled", "stepIds": [{"deliveryId": "t-nilus-57", "activityType": "pickup"}, {"deliveryId": "t-nilus-57", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-large"}	2017-11-30 17:49:40.719752	2017-11-30 17:49:40.719752
762fd09a-e6bb-40b7-99ad-c23efec7e789	\N	canceled	\N	375.0000	2017-11-16 17:00:00	[{"notes": null, "place": "Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina", "latlng": "-32.9396, -60.679", "address": {"id": "54a1d9a5-5894-4e6a-b17d-aab2ff8de98c", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Bv. Avellaneda 853", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Aislanpor", "email": "jejimenez@gmail.com", "cellphone": "0341 4392743"}, "open_hours": null, "delivery_id": 8}]	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 8}]	Shippify	t-nilus-58	{"id": "t-nilus-58", "city": {"id": "20", "name": "Rosario"}, "status": "canceled", "stepIds": [{"deliveryId": "t-nilus-58", "activityType": "pickup"}, {"deliveryId": "t-nilus-58", "activityType": "dropoff"}], "distances": [1.9], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:43.183779	2017-11-30 17:49:43.183779
d8973aab-9e40-4f93-ae18-ab2ffc07fbad	ebadec9c-cfdf-455b-8934-09b016649b9f	completed	\N	375.0000	2017-11-16 17:00:00	[{"notes": null, "place": "Bv. Avellaneda 853, S2002 Rosario, Santa Fe, Argentina", "latlng": "-32.9396, -60.679", "address": {"id": "54a1d9a5-5894-4e6a-b17d-aab2ff8de98c", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Bv. Avellaneda 853", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Aislanpor", "email": "jejimenez@gmail.com", "cellphone": "0341 4392743"}, "open_hours": null, "delivery_id": 9}]	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 9}]	Shippify	t-nilus-59	{"id": "t-nilus-59", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-59", "activityType": "pickup"}, {"deliveryId": "t-nilus-59", "activityType": "dropoff"}], "distances": [1.9], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:44.190403	2017-11-30 17:49:44.190403
bba29b5e-af56-4e13-8a56-ebddcc35bfcc	7862d386-3ed8-4613-9d20-fb7eac91b02d	completed	\N	375.0000	2017-11-17 13:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 10}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 10}]	Shippify	t-nilus-60	{"id": "t-nilus-60", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-60", "activityType": "pickup"}, {"deliveryId": "t-nilus-60", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "large"}	2017-11-30 17:49:46.508482	2017-11-30 17:49:46.508482
de95a9e2-99c3-4206-a16b-5a5eecfad423	6701166a-f5bc-4b62-bd66-29c810a4425c	completed	\N	375.0000	2017-11-21 13:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 11}]	[{"notes": "-", "place": "223 - Asociación Civil Alas Para Crecer", "latlng": "-32.991, -60.6355", "address": {"id": "975e51f6-c9bf-4ddc-86eb-0f8ab995b3fd", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Medici 4620", "street_2": null, "zip_code": "S2001GKB", "telephone": null}, "contact": {"name": "Roxana Mansilla ", "email": "", "cellphone": "156936337"}, "open_hours": null, "delivery_id": 11}]	Shippify	t-nilus-61	{"id": "t-nilus-61", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-61", "activityType": "pickup"}, {"deliveryId": "t-nilus-61", "activityType": "dropoff"}], "distances": [24.1], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "large"}	2017-11-30 17:49:47.690268	2017-11-30 17:49:47.690268
3802c42c-24ec-4916-ba8e-4795e74cb464	6701166a-f5bc-4b62-bd66-29c810a4425c	completed	\N	375.0000	2017-11-23 11:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 12}]	[{"notes": "Pasillo", "place": "213 - Solcito", "latlng": "-32.9632, -60.6875", "address": {"id": "da180da3-937f-492f-b99a-6d671834a610", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Rueda 4265", "street_2": null, "zip_code": null, "telephone": null}, "contact": {"name": "Sandra Arce", "email": "", "cellphone": "153480194"}, "open_hours": null, "delivery_id": 12}]	Shippify	t-nilus-62	{"id": "t-nilus-62", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-62", "activityType": "pickup"}, {"deliveryId": "t-nilus-62", "activityType": "dropoff"}], "distances": [4.5], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "large"}	2017-11-30 17:49:48.715577	2017-11-30 17:49:48.715577
cf3a82be-df03-4df4-b09f-8adda536e873	6701166a-f5bc-4b62-bd66-29c810a4425c	completed	\N	375.0000	2017-11-23 12:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 13}]	[{"notes": "-", "place": "97 - San Cayetano", "latlng": "-32.924, -60.7061", "address": {"id": "7f891cb3-ce32-45aa-bd9b-6d705f060ef7", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Gorriti 6080", "street_2": null, "zip_code": "S2007BQT", "telephone": null}, "contact": {"name": "Mirta Barrios", "email": "", "cellphone": "155484625"}, "open_hours": null, "delivery_id": 13}]	Shippify	t-nilus-63	{"id": "t-nilus-63", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-63", "activityType": "pickup"}, {"deliveryId": "t-nilus-63", "activityType": "dropoff"}], "distances": [2.7], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-large"}	2017-11-30 17:49:49.841391	2017-11-30 17:49:49.841391
ab4594d6-cda1-4439-87dc-b8207795f04d	7862d386-3ed8-4613-9d20-fb7eac91b02d	completed	\N	375.0000	2017-11-24 13:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 14}]	[{"notes": null, "place": "Comandos 602 4384, Rosario, Santa Fe, Argentina", "latlng": "-32.9806, -60.6965", "address": {"id": "3b2a2d3d-c7ac-40e9-80be-08f77f3f76d8", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Comandos 602 4384", "street_2": null, "zip_code": null, "telephone": null}, "contact": {"name": "Angela rosa de los santos", "email": "155093278@shippify.co", "cellphone": "155093278"}, "open_hours": null, "delivery_id": 14}]	Shippify	t-nilus-64	{"id": "t-nilus-64", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-64", "activityType": "pickup"}, {"deliveryId": "t-nilus-64", "activityType": "dropoff"}], "distances": [6.9], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:50.881006	2017-11-30 17:49:50.881006
cab81027-6488-4a06-9468-b8d1eb79474b	ebadec9c-cfdf-455b-8934-09b016649b9f	completed	\N	375.0000	2017-11-27 13:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 15}]	[{"notes": "-", "place": "223 - Asociación Civil Alas Para Crecer", "latlng": "-32.991, -60.6355", "address": {"id": "975e51f6-c9bf-4ddc-86eb-0f8ab995b3fd", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Medici 4620", "street_2": null, "zip_code": "S2001GKB", "telephone": null}, "contact": {"name": "Roxana Mansilla ", "email": "", "cellphone": "156936337"}, "open_hours": null, "delivery_id": 15}]	Shippify	t-nilus-65	{"id": "t-nilus-65", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-65", "activityType": "pickup"}, {"deliveryId": "t-nilus-65", "activityType": "dropoff"}], "distances": [24.1], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:51.989313	2017-11-30 17:49:51.989313
a4b8cff9-daa2-4f37-bb75-705a255c1da0	3089fc3f-5d9c-43bf-a8d8-63d1b84c5c2c	completed	\N	375.0000	2017-11-25 14:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 16}]	[{"notes": "-", "place": "97 - San Cayetano", "latlng": "-32.924, -60.7061", "address": {"id": "7f891cb3-ce32-45aa-bd9b-6d705f060ef7", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Gorriti 6080", "street_2": null, "zip_code": "S2007BQT", "telephone": null}, "contact": {"name": "Mirta Barrios", "email": "", "cellphone": "155484625"}, "open_hours": null, "delivery_id": 16}]	Shippify	t-nilus-66	{"id": "t-nilus-66", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-66", "activityType": "pickup"}, {"deliveryId": "t-nilus-66", "activityType": "dropoff"}], "distances": [2.7], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-small"}	2017-11-30 17:49:53.020605	2017-11-30 17:49:53.020605
2dc49d9a-accf-4107-b88d-781f8b44647e	3089fc3f-5d9c-43bf-a8d8-63d1b84c5c2c	completed	\N	375.0000	2017-11-25 16:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 17}]	[{"notes": "-", "place": "97 - San Cayetano", "latlng": "-32.924, -60.7061", "address": {"id": "7f891cb3-ce32-45aa-bd9b-6d705f060ef7", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Gorriti 6080", "street_2": null, "zip_code": "S2007BQT", "telephone": null}, "contact": {"name": "Mirta Barrios", "email": "", "cellphone": "155484625"}, "open_hours": null, "delivery_id": 17}]	Shippify	t-nilus-67	{"id": "t-nilus-67", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-67", "activityType": "pickup"}, {"deliveryId": "t-nilus-67", "activityType": "dropoff"}], "distances": [2.7], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-small"}	2017-11-30 17:49:53.989277	2017-11-30 17:49:53.989277
376bc458-bc3f-44eb-a8f7-87addce00143	7862d386-3ed8-4613-9d20-fb7eac91b02d	completed	\N	375.0000	2017-11-28 12:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 18}]	[{"notes": "Pasillo", "place": "213 - Solcito", "latlng": "-32.9632, -60.6875", "address": {"id": "da180da3-937f-492f-b99a-6d671834a610", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Rueda 4265", "street_2": null, "zip_code": null, "telephone": null}, "contact": {"name": "Sandra Arce", "email": "", "cellphone": "153480194"}, "open_hours": null, "delivery_id": 18}]	Shippify	t-nilus-68	{"id": "t-nilus-68", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-68", "activityType": "pickup"}, {"deliveryId": "t-nilus-68", "activityType": "dropoff"}], "distances": [4.5], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:54.937541	2017-11-30 17:49:54.937541
1505f31b-5c68-49ae-a0eb-4696478d8932	6701166a-f5bc-4b62-bd66-29c810a4425c	completed	\N	375.0000	2017-11-30 11:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 19}]	[{"notes": "-", "place": "97 - San Cayetano", "latlng": "-32.924, -60.7061", "address": {"id": "7f891cb3-ce32-45aa-bd9b-6d705f060ef7", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Gorriti 6080", "street_2": null, "zip_code": "S2007BQT", "telephone": null}, "contact": {"name": "Mirta Barrios", "email": "", "cellphone": "155484625"}, "open_hours": null, "delivery_id": 19}]	Shippify	t-nilus-69	{"id": "t-nilus-69", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-69", "activityType": "pickup"}, {"deliveryId": "t-nilus-69", "activityType": "dropoff"}], "distances": [2.7], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "x-large"}	2017-11-30 17:49:55.985003	2017-11-30 17:49:55.985003
c03b5ea8-3f68-4552-867f-2dcf62f1a911	7862d386-3ed8-4613-9d20-fb7eac91b02d	completed	\N	375.0000	2017-11-30 12:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 20}]	[{"notes": "-", "place": "Asociación Civil Evita Sol Naciente", "latlng": "-32.9799, -60.6619", "address": {"id": "8ea6c4fb-4f39-4905-a133-f132909e5bde", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Pres. Quintana 2173", "street_2": null, "zip_code": "S2001ARQ", "telephone": null}, "contact": {"name": "Isabel Berizzo", "email": "", "cellphone": "156179787"}, "open_hours": null, "delivery_id": 20}]	Shippify	t-nilus-70	{"id": "t-nilus-70", "city": {"id": "20", "name": "Rosario"}, "status": "completed", "stepIds": [{"deliveryId": "t-nilus-70", "activityType": "pickup"}, {"deliveryId": "t-nilus-70", "activityType": "dropoff"}], "distances": [8.3], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:57.027758	2017-11-30 17:49:57.027758
1eea1975-804c-46f1-aa63-19563499a289	\N	processing	\N	375.0000	2017-11-30 20:00:00	[{"notes": "-", "place": "BAR", "latlng": "-32.9321, -60.6874", "address": {"id": "6d52cf7d-ffa5-444e-bd57-b709ebf588f9", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Carriego 360", "street_2": null, "zip_code": "S2002", "telephone": null}, "contact": {"name": "Karina Campos", "email": "karinacamposrodriguez@gmail.com", "cellphone": "5491167481432"}, "open_hours": null, "delivery_id": 21}]	[{"notes": "Pasillo", "place": "213 - Solcito", "latlng": "-32.9632, -60.6875", "address": {"id": "da180da3-937f-492f-b99a-6d671834a610", "city": "Rosario", "state": "Santa Fe", "country": "Argentina", "street_1": "Rueda 4265", "street_2": null, "zip_code": null, "telephone": null}, "contact": {"name": "Sandra Arce", "email": "", "cellphone": "153480194"}, "open_hours": null, "delivery_id": 21}]	Shippify	t-nilus-71	{"id": "t-nilus-71", "city": {"id": "20", "name": "Rosario"}, "status": "processing", "stepIds": [{"deliveryId": "t-nilus-71", "activityType": "pickup"}, {"deliveryId": "t-nilus-71", "activityType": "dropoff"}], "distances": [4.5], "referenceId": null, "currencyCode": "ARS", "minimumCapacity": "medium"}	2017-11-30 17:49:58.019059	2017-11-30 17:49:58.019059
\.


--

--

COPY users (id, username, email, password_digest, token_expire_at, login_count, failed_login_count, last_login_at, last_login_ip, active, confirmed, roles_mask, settings, deleted_at, created_at, updated_at) FROM stdin;
8431fc86-e3de-4dcc-a072-9aa2fcf9fc0d	karen	karen@winguweb.org	$2a$10$sCaiNs1yiQ8mbSW5On0a9OY5iQuAfQDq1irZfTd4uowodo4Nsyuzi	\N	0	0	\N	\N	f	f	\N	{}	\N	2017-11-30 17:48:49.73275	2017-11-30 17:48:49.73275
5e803a5d-7239-4f41-b188-130a019ebc63	cavi	agustin@winguweb.org	$2a$10$OkmStmfk0VJLqV1ST4cglOh8kx.rqHTAS9gtCCMjXz9bpiw/d8XFy	\N	0	0	\N	\N	f	f	\N	{}	\N	2017-11-30 17:48:49.798478	2017-11-30 17:48:49.798478
579fe08b-3005-4198-9a46-a0f82bf520cc	facu	facundo@winguweb.org	$2a$10$DIjS.5KondC6ZHWQDZd9y.D.FSXNeu5s5Qf6prRmcOcSCCLRK0d9i	\N	0	0	\N	\N	f	f	\N	{}	\N	2017-11-30 17:48:49.861382	2017-11-30 17:48:49.861382
14bba3b8-62d4-4c28-acfb-d4b8f5bf5fc8	carlos	carlos@winguweb.org	$2a$10$9IHItk0jv1sO9cPSXPafJeXsYeoJbn3AWefZNV1PFpQhFCvYVdkHa	\N	0	0	\N	\N	f	f	\N	{}	\N	2017-11-30 17:48:49.926249	2017-11-30 17:48:49.926249
\.


--

--

COPY vehicles (id, shipper_id, model, brand, year, extras, created_at, updated_at) FROM stdin;
88e083da-ff6a-4330-ab94-6de72797ecc7	8b714a02-4ba2-4747-ae22-b145a3786d7e	FORD F 100	\N	1977	{"capacity": 5, "gateway_id": 8750}	2017-11-30 17:49:09.553887	2017-11-30 17:49:09.553887
2e0df63a-45d6-421f-ad89-d7758b6ad8cc	d07f8aa6-c0fa-44ed-bc71-d59dbce6c6bd	carro	\N	0	{"capacity": 3, "gateway_id": 6368}	2017-11-30 17:49:09.808014	2017-11-30 17:49:09.808014
3a5a2685-4be7-4601-b37b-888bfc8685b5	ebadec9c-cfdf-455b-8934-09b016649b9f	Pick up Chevrolet S10 2.8 TDI STD 4x2 ca	\N	2006	{"capacity": 5, "gateway_id": 9142}	2017-11-30 17:49:10.287965	2017-11-30 17:49:10.287965
26aaecdc-e94a-4feb-9e6f-7a2c6ac77701	7cc00e49-c481-4516-92a0-8046d8a992fd	Test Type	\N	0	{"capacity": 3, "gateway_id": 4177}	2017-11-30 17:49:10.886228	2017-11-30 17:49:10.886228
6fa0e918-f9e5-4f18-ba4a-906e7823deda	841c13b0-083e-4c7f-a623-6e23abd90454	-	\N	0	{"capacity": 5, "gateway_id": 8748}	2017-11-30 17:49:11.101387	2017-11-30 17:49:11.101387
239bedf9-7721-4136-af57-3e9e3ab1a3ed	3089fc3f-5d9c-43bf-a8d8-63d1b84c5c2c	-	\N	0	{"capacity": 5, "gateway_id": 8749}	2017-11-30 17:49:11.317931	2017-11-30 17:49:11.317931
6ba1d235-e52b-4678-b778-da69ab2a4463	7dd811d0-00c0-4116-912b-4a35b5685a65	carro	\N	0	{"capacity": 3, "gateway_id": 6367}	2017-11-30 17:49:11.824439	2017-11-30 17:49:11.824439
9e23c312-2a6f-46c5-bd58-bd73911e919c	7862d386-3ed8-4613-9d20-fb7eac91b02d	Kangoo confort 1.6 5A CD SVT 600 K	\N	2011	{"capacity": 4, "gateway_id": 9037}	2017-11-30 17:49:12.255412	2017-11-30 17:49:12.255412
46f6a733-8108-46fd-a52e-99b4ce6ad981	6701166a-f5bc-4b62-bd66-29c810a4425c	Chevrolet Pick up C-20 custom	\N	1993	{"capacity": 5, "gateway_id": 9030}	2017-11-30 17:49:13.26314	2017-11-30 17:49:13.26314
99bc95b2-7d59-4357-b65b-5acab4b8c979	5f5a02ea-9bc8-4d62-a18a-e6abf04c67c9	Peugeot Partner confort HDI 1.6	\N	2012	{"capacity": 5, "gateway_id": 9098}	2017-11-30 17:49:13.477997	2017-11-30 17:49:13.477997
\.


--

--

COPY verifications (id, verificable_type, verificable_id, data, verified_at, verified_by, expire, expire_at, created_at, updated_at) FROM stdin;
1	Vehicle	88e083da-ff6a-4330-ab94-6de72797ecc7	{":type": "license_plate", ":information": {":number": "WUY733"}}	\N	\N	\N	\N	2017-11-30 17:49:09.55563	2017-11-30 17:49:09.55563
2	Vehicle	2e0df63a-45d6-421f-ad89-d7758b6ad8cc	{":type": "license_plate", ":information": {":number": "undefined"}}	\N	\N	\N	\N	2017-11-30 17:49:09.809369	2017-11-30 17:49:09.809369
3	Vehicle	3a5a2685-4be7-4601-b37b-888bfc8685b5	{":type": "license_plate", ":information": {":number": "FKC634"}}	\N	\N	\N	\N	2017-11-30 17:49:10.289442	2017-11-30 17:49:10.289442
4	Vehicle	26aaecdc-e94a-4feb-9e6f-7a2c6ac77701	{":type": "license_plate", ":information": {":number": "12345123"}}	\N	\N	\N	\N	2017-11-30 17:49:10.88768	2017-11-30 17:49:10.88768
5	Vehicle	6fa0e918-f9e5-4f18-ba4a-906e7823deda	{":type": "license_plate", ":information": {":number": "-"}}	\N	\N	\N	\N	2017-11-30 17:49:11.102983	2017-11-30 17:49:11.102983
6	Vehicle	239bedf9-7721-4136-af57-3e9e3ab1a3ed	{":type": "license_plate", ":information": {":number": "-"}}	\N	\N	\N	\N	2017-11-30 17:49:11.319519	2017-11-30 17:49:11.319519
7	Vehicle	6ba1d235-e52b-4678-b778-da69ab2a4463	{":type": "license_plate", ":information": {":number": "undefined"}}	\N	\N	\N	\N	2017-11-30 17:49:11.825852	2017-11-30 17:49:11.825852
8	Vehicle	9e23c312-2a6f-46c5-bd58-bd73911e919c	{":type": "license_plate", ":information": {":number": "JXT242"}}	\N	\N	\N	\N	2017-11-30 17:49:12.256734	2017-11-30 17:49:12.256734
9	Vehicle	46f6a733-8108-46fd-a52e-99b4ce6ad981	{":type": "license_plate", ":information": {":number": "TZD762"}}	\N	\N	\N	\N	2017-11-30 17:49:13.264506	2017-11-30 17:49:13.264506
10	Vehicle	99bc95b2-7d59-4357-b65b-5acab4b8c979	{":type": "license_plate", ":information": {":number": "LMQ359"}}	\N	\N	\N	\N	2017-11-30 17:49:13.479241	2017-11-30 17:49:13.479241
\.


--

--

SELECT pg_catalog.setval('deliveries_id_seq', 21, true);


--

--

SELECT pg_catalog.setval('packages_id_seq', 34, true);


--

--

SELECT pg_catalog.setval('verifications_id_seq', 10, true);


--

--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--

--

ALTER TABLE ONLY bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY institutions
    ADD CONSTRAINT institutions_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY packages
    ADD CONSTRAINT packages_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--

--

ALTER TABLE ONLY shippers
    ADD CONSTRAINT shippers_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--

--

ALTER TABLE ONLY verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);


--

--

CREATE INDEX index_addresses_on_gateway_data ON addresses USING gin (gateway_data);


--

--

CREATE INDEX index_addresses_on_gps_coordinates ON addresses USING gist (gps_coordinates);


--

--

CREATE INDEX index_addresses_on_institution_id ON addresses USING btree (institution_id);


--

--

CREATE INDEX index_bank_accounts_on_shipper_id ON bank_accounts USING btree (shipper_id);


--

--

CREATE INDEX index_deliveries_on_destination_gps_coordinates ON deliveries USING gist (destination_gps_coordinates);


--

--

CREATE INDEX index_deliveries_on_destination_id ON deliveries USING btree (destination_id);


--

--

CREATE INDEX index_deliveries_on_gateway_data ON deliveries USING gin (gateway_data);


--

--

CREATE INDEX index_deliveries_on_order_id ON deliveries USING btree (order_id);


--

--

CREATE INDEX index_deliveries_on_origin_gps_coordinates ON deliveries USING gist (origin_gps_coordinates);


--

--

CREATE INDEX index_deliveries_on_origin_id ON deliveries USING btree (origin_id);


--

--

CREATE INDEX index_deliveries_on_trip_id ON deliveries USING btree (trip_id);


--

--

CREATE INDEX index_orders_on_giver_id ON orders USING btree (giver_id);


--

--

CREATE INDEX index_orders_on_receiver_id ON orders USING btree (receiver_id);


--

--

CREATE INDEX index_packages_on_attachment_id ON packages USING btree (attachment_id);


--

--

CREATE INDEX index_packages_on_delivery_id ON packages USING btree (delivery_id);


--

--

CREATE INDEX index_profiles_on_preferences ON profiles USING gin (preferences);


--

--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--

--

CREATE INDEX index_shippers_on_data ON shippers USING gin (data);


--

--

CREATE INDEX index_shippers_on_minimum_requirements ON shippers USING gin (minimum_requirements);


--

--

CREATE INDEX index_shippers_on_national_ids ON shippers USING gin (national_ids);


--

--

CREATE INDEX index_shippers_on_requirements ON shippers USING gin (requirements);


--

--

CREATE INDEX index_trips_on_dropoffs ON trips USING gin (dropoffs);


--

--

CREATE INDEX index_trips_on_gateway_data ON trips USING gin (gateway_data);


--

--

CREATE INDEX index_trips_on_pickups ON trips USING gin (pickups);


--

--

CREATE INDEX index_trips_on_shipper_id ON trips USING btree (shipper_id);


--

--

CREATE INDEX index_users_on_email ON users USING btree (email);


--

--

CREATE INDEX index_users_on_roles_mask ON users USING btree (roles_mask);


--

--

CREATE INDEX index_users_on_settings ON users USING gin (settings);


--

--

CREATE INDEX index_users_on_username ON users USING btree (username);


--

--

CREATE INDEX index_vehicles_on_extras ON vehicles USING gin (extras);


--

--

CREATE INDEX index_vehicles_on_shipper_id ON vehicles USING btree (shipper_id);


--

--

CREATE INDEX index_verifications_on_data ON verifications USING gin (data);


--

--

CREATE INDEX index_verifications_on_verificable_type_and_verificable_id ON verifications USING btree (verificable_type, verificable_id);


--

--

ALTER TABLE ONLY vehicles
    ADD CONSTRAINT fk_rails_15393ee91e FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--

--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT fk_rails_3eba625948 FOREIGN KEY (order_id) REFERENCES orders(id);


--

--

ALTER TABLE ONLY trips
    ADD CONSTRAINT fk_rails_64fc3626a2 FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--

--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT fk_rails_6a5d8705d2 FOREIGN KEY (institution_id) REFERENCES institutions(id);


--

--

ALTER TABLE ONLY deliveries
    ADD CONSTRAINT fk_rails_6ec721b21e FOREIGN KEY (trip_id) REFERENCES trips(id);


--

--

ALTER TABLE ONLY bank_accounts
    ADD CONSTRAINT fk_rails_91b14e7155 FOREIGN KEY (shipper_id) REFERENCES shippers(id);


--

--

ALTER TABLE ONLY packages
    ADD CONSTRAINT fk_rails_e7fe3e94f2 FOREIGN KEY (delivery_id) REFERENCES deliveries(id);


--
-- PostgreSQL database dump complete
--


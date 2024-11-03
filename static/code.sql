-- Create table for users
CREATE TABLE users (
	id	        INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	name	    TEXT NOT NULL,
	hash	    TEXT NOT NULL,
	PRIMARY KEY(id)
);
CREATE UNIQUE INDEX username ON users(name);

-- Create a table for clients
CREATE TABLE clients (
    id              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    name            TEXT NOT NULL,
    phone           TEXT NOT NULL,
    email           TEXT,
    company         TEXT
);
CREATE UNIQUE INDEX clientphone ON clients(phone);
CREATE UNIQUE INDEX clientemail ON clients(email);

-- Create table for jobs
CREATE TABLE jobs (
	id	            INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	client_id	    INTEGER NOT NULL,
	permission	    TEXT,
	address	        TEXT NOT NULL,
	status	        TEXT NOT NULL,
	FOREIGN KEY(client_id) REFERENCES clients(id)
);

CREATE TABLE Jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER, start_date DATE,
    job_title TEXT NOT NULL,
    description TEXT NOT NULL,
    end_date DATE, status TEXT,
    assigned_to TEXT,
    estimated_cost REAL,
    actual_cost REAL,
    FOREIGN KEY (client_id) REFERENCES ClientCompanies(id) );


-- Create table for Wiring and Cabling
CREATE TABLE WiringCabling (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Connectors and Fasteners
CREATE TABLE ConnectorsFasteners (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Conduit and Accessories
CREATE TABLE ConduitAccessories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Electrical Boxes and Plates
CREATE TABLE ElectricalBoxesPlates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Outlets, Switches, and Controls
CREATE TABLE OutletsSwitchesControls (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Lighting
CREATE TABLE Lighting (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Circuit Breakers and Panels
CREATE TABLE CircuitBreakersPanels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Safety Devices
CREATE TABLE SafetyDevices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Tools and Safety Gear
CREATE TABLE ToolsSafetyGear (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Create table for Accessories
CREATE TABLE Accessories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT
);

-- Insert data into WiringCabling
INSERT INTO WiringCabling (name, description) VALUES
('Romex wire', 'A type of electrical wire used in residential wiring'),
('THHN wire', 'Thermoplastic High Heat-resistant Nylon-coated wire'),
('Ground wire', 'A wire that provides a path to ground for electrical current'),
('Cable ties', 'Plastic fasteners used to bundle cables together');

-- Insert data into ConnectorsFasteners
INSERT INTO ConnectorsFasteners (name, description) VALUES
('Wire nuts', 'Connectors used to fasten electrical wires together'),
('Crimp connectors', 'Connectors used to secure electrical connections by crimping'),
('Cable staples', 'Fasteners used to secure cables to a surface'),
('Cable connectors', 'Connectors used to join cables');

-- Insert data into ConduitAccessories
INSERT INTO ConduitAccessories (name, description) VALUES
('PVC conduit', 'Plastic conduit used to protect electrical wiring'),
('Metal conduit (EMT, FMC)', 'Metal conduit used to protect electrical wiring'),
('Conduit fittings', 'Elbows, couplings, and connectors for conduit');

-- Insert data into ElectricalBoxesPlates
INSERT INTO ElectricalBoxesPlates (name, description) VALUES
('Metal electrical boxes', 'Boxes used to house electrical connections'),
('Plastic electrical boxes', 'Boxes used to house electrical connections'),
('Old work boxes', 'Electrical boxes used for retrofit installations'),
('Blank faceplates', 'Cover plates for unused electrical boxes'),
('Decorative faceplates', 'Aesthetic cover plates for electrical outlets and switches');

-- Insert data into OutletsSwitchesControls
INSERT INTO OutletsSwitchesControls (name, description) VALUES
('Standard wall outlets', '120V electrical receptacles'),
('GFCI outlets', 'Ground Fault Circuit Interrupter outlets'),
('USB outlets', 'Electrical outlets with built-in USB ports'),
('Standard light switches', 'Basic on/off switches for lights'),
('Dimmer switches', 'Switches that allow you to adjust the brightness of lights'),
('3-way switches', 'Switches that allow control of a light from two locations'),
('Thermostats', 'Devices used to control the temperature');

-- Insert data into Lighting
INSERT INTO Lighting (name, description) VALUES
('Recessed light fixtures', 'Light fixtures installed into the ceiling'),
('Surface-mounted light fixtures', 'Light fixtures mounted on the surface of the ceiling'),
('Ceiling fan/light combo units', 'Combination units with a ceiling fan and light'),
('LED bulbs', 'Energy-efficient light bulbs using LED technology'),
('Compact fluorescent bulbs', 'Energy-efficient light bulbs using fluorescent technology');

-- Insert data into CircuitBreakersPanels
INSERT INTO CircuitBreakersPanels (name, description) VALUES
('Main breaker panel', 'Main electrical panel that distributes power'),
('Subpanel', 'Additional electrical panel for distributing power'),
('Circuit breakers', 'Devices that automatically interrupt electrical circuits'),
('Busbars', 'Metal strips used for conducting electricity within a panel');

-- Insert data into SafetyDevices
INSERT INTO SafetyDevices (name, description) VALUES
('Smoke detectors', 'Devices that detect smoke and sound an alarm'),
('Carbon monoxide detectors', 'Devices that detect carbon monoxide and sound an alarm'),
('Surge protectors', 'Devices that protect electrical equipment from surges'),
('AFCI breakers', 'Arc Fault Circuit Interrupters that protect against arc faults');

-- Insert data into ToolsSafetyGear
INSERT INTO ToolsSafetyGear (name, description) VALUES
('Wire strippers', 'Tools used to strip insulation from electrical wires'),
('Pliers', 'Tools used for gripping and bending wires'),
('Screwdrivers', 'Tools used for driving screws'),
('Voltage tester', 'Tool used to test the presence of voltage'),
('Multimeter', 'Tool used to measure electrical properties such as voltage, current, and resistance'),
('Fish tape', 'Tool used to pull wire through conduit'),
('Drill and bits', 'Tools used for drilling holes'),
('Hammer', 'Tool used for driving nails'),
('Safety goggles', 'Protective eyewear'),
('Insulated gloves', 'Gloves used to protect against electrical shock');

-- Insert data into Accessories
INSERT INTO Accessories (name, description) VALUES
('Electrical tape', 'Tape used for insulating electrical wires and connections'),
('Heat shrink tubing', 'Tubing used to insulate wires'),
('Cable clamps', 'Clamps used to secure cables'),
('Junction boxes', 'Boxes used to house electrical connections');

-- Create the database
CREATE DATABASE ResidentialElectricalTasks;

-- Use the database
USE ResidentialElectricalTasks;

-- Create table for ProjectTasks
CREATE TABLE ProjectTasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL,
    description TEXT,
    status TEXT,
    assigned_to TEXT,
    priority INTEGER,
    start_date DATE,
    due_date DATE
);

-- Insert data into ProjectTasks
INSERT INTO ProjectTasks (task_name, description, status, assigned_to, priority, start_date, due_date) VALUES
('Plan electrical layout', 'Design the layout for electrical wiring and components', 'Not Started', 'John Doe', 1, '2024-11-02', '2024-11-05'),
('Install main breaker panel', 'Install the main electrical panel for the house', 'Not Started', 'Jane Smith', 2, '2024-11-06', '2024-11-10'),
('Run wiring', 'Install the electrical wiring throughout the house', 'Not Started', 'John Doe', 3, '2024-11-11', '2024-11-15'),
('Install outlets and switches', 'Install wall outlets and light switches', 'Not Started', 'Jane Smith', 4, '2024-11-16', '2024-11-20'),
('Install lighting fixtures', 'Install all ceiling lights, fans, and fixtures', 'Not Started', 'John Doe', 5, '2024-11-21', '2024-11-25'),
('Install GFCI outlets', 'Install Ground Fault Circuit Interrupter outlets in required areas', 'Not Started', 'Jane Smith', 6, '2024-11-26', '2024-11-30'),
('Conduct safety checks', 'Inspect and test all electrical installations for safety', 'Not Started', 'John Doe', 7, '2024-12-01', '2024-12-05'),
('Final inspection', 'Perform a final inspection to ensure all work meets code', 'Not Started', 'Jane Smith', 8, '2024-12-06', '2024-12-10');

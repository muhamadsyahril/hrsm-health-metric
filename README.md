# Hrsma Health Metrics Application

A complete Salesforce solution for managing health metrics including BMI calculations.

## Features

1. **REST API for Lead Creation** - Custom Apex REST service to create leads with health metrics
2. **Automated Lead Conversion** - Automatically converts qualified leads to accounts
3. **BMI Calculator** - Lightning Aura Component for calculating and tracking BMI

## Prerequisites

- Salesforce CLI installed
- Visual Studio Code with Salesforce Extensions
- DevHub enabled in your Salesforce org

## Installation

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd hrsm-health-metrics
```

### 2. Authorize Your DevHub

```bash
sf org login web --set-default-dev-hub --alias myDevHub
```

### 3. Create a Scratch Org

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias HrsmHealthMetricsScratch --duration-days 30 --set-default
```

### 4. Push Source to Scratch Org

```bash
sf project deploy start
```

### 5. Assign Permission Set (if created)

```bash
sf org assign permset --name Hrsm_Access
```

### 6. Open the Scratch Org

```bash
sf org open
```

## Project Structure

```
force-app/
├── main/
│   └── default/
│       ├── classes/
│       │   ├── CustomLeadWebService.cls
│       │   ├── CustomLeadWebService.cls-meta.xml
│       │   ├── CustomLeadWebServiceTest.cls
│       │   ├── CustomLeadWebServiceTest.cls-meta.xml
│       │   ├── LeadConversionProcessor.cls
│       │   ├── LeadConversionProcessor.cls-meta.xml
│       │   ├── LeadConversionProcessorTest.cls
│       │   ├── LeadConversionProcessorTest.cls-meta.xml
│       │   ├── HealthMetricsApexController.cls
│       │   ├── HealthMetricsApexController.cls-meta.xml
│       │   ├── HealthMetricsApexControllerTest.cls
│       │   └── HealthMetricsApexControllerTest.cls-meta.xml
│       ├── triggers/
│       │   ├── AutoLeadConversionTrigger.trigger
│       │   └── AutoLeadConversionTrigger.trigger-meta.xml
│       ├── aura/
│       │   └── HealthMetricsCalculator/
│       │       ├── HealthMetricsCalculator.cmp
│       │       ├── HealthMetricsCalculator.cmp-meta.xml
│       │       ├── HealthMetricsCalculatorController.js
│       │       ├── HealthMetricsCalculatorHelper.js
│       │       └── HealthMetricsCalculator.css
│       └── objects/
│           ├── Lead/
│           │   └── fields/
│           │       ├── Weight__c.field-meta.xml
│           │       ├── Height__c.field-meta.xml
│           │       └── ExternalId__c.field-meta.xml
│           └── Account/
│               └── fields/
│                   ├── Weight__c.field-meta.xml
│                   ├── Height__c.field-meta.xml
│                   ├── Age__c.field-meta.xml
│                   ├── BMI__c.field-meta.xml
│                   └── Weight_Status__c.field-meta.xml
```

## Testing

### Run All Tests

```bash
sf apex run test --test-level RunLocalTests --result-format human --code-coverage
```

### Run Specific Test Class

```bash
sf apex run test --tests CustomLeadWebServiceTest --result-format human --code-coverage
```

## Usage

### 1. REST API Endpoint

**Endpoint:** `/services/apexrest/api/v1/customlead/`

**Sample cURL Request:**

```bash
curl -X POST \
  'https://yourInstance.my.salesforce.com/services/apexrest/api/v1/customlead/' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "FirstName": "John",
    "LastName": "Doe",
    "Phone": "1234567890",
    "Email": "john.doe@example.com",
    "Street": "123 Main St",
    "City": "San Francisco",
    "State": "CA",
    "Country": "USA",
    "PostalCode": "94105",
    "Weight": 75.5,
    "Height": 1.75,
    "ExternalId": "EXT123"
}'
```

### 2. BMI Calculator Component

Add the component to Account pages:
1. Navigate to an Account record
2. Click Setup → Edit Page
3. Drag **HealthMetricsCalculator** component onto the page
4. Save and activate

### 3. Lead Auto Conversion

Leads automatically convert when all required fields are populated:
- Phone
- Email
- Weight__c
- Height__c
- ExternalId__c

## Development Commands

```bash
# Create scratch org
sf org create scratch -f config/project-scratch-def.json -a myScratch

# Push source
sf project deploy start

# Pull changes
sf project retrieve start

# Delete scratch org
sf org delete scratch -o myScratch

# View org details
sf org display

# Generate password
sf org generate password
```

## License

MIT License

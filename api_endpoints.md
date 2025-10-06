# API Endpoints Specification
## Dauphins Condo Management System

This document outlines all REST API endpoints using Supabase client for the ERP system.

---

## Authentication Endpoints

### POST /auth/signup
Register a new user
```typescript
// Request
{
  email: string;
  password: string;
  full_name: string;
  role?: 'owner' | 'tenant'; // Default role, admin assigns final role
}

// Response
{
  user: User;
  session: Session;
}
```

### POST /auth/login
Authenticate user
```typescript
// Request
{
  email: string;
  password: string;
}

// Response
{
  user: User;
  session: Session;
}
```

### POST /auth/logout
End user session

### POST /auth/reset-password
Request password reset
```typescript
// Request
{
  email: string;
}
```

### POST /auth/update-password
Update password with reset token
```typescript
// Request
{
  password: string;
}
```

---

## Owner Management

### GET /api/owners
List all owners (Admin only)
```typescript
// Query Parameters
{
  page?: number;
  limit?: number;
  search?: string;
  building_section?: string;
}

// Response
{
  data: Owner[];
  total: number;
  page: number;
  limit: number;
}
```

### GET /api/owners/:id
Get owner details
```typescript
// Response
{
  id: string;
  user: User;
  unit: Unit;
  parking_spaces: ParkingSpace[];
  lockers: Locker[];
  insurance_policies: InsurancePolicy[];
  primary_residence: boolean;
  mailing_address: Address;
  emergency_contact: Contact;
  ownership_start_date: string;
  pre_authorized_payments: boolean;
}
```

### POST /api/owners
Create new owner (Admin only)
```typescript
// Request
{
  user_id: string;
  unit_id: string;
  primary_residence: boolean;
  mailing_address: Address;
  emergency_contact: Contact;
  ownership_start_date: string;
  pre_authorized_payments: boolean;
  pre_authorized_payment_doc_url?: string;
}
```

### PATCH /api/owners/:id
Update owner information
```typescript
// Request (partial update)
{
  primary_residence?: boolean;
  mailing_address?: Address;
  emergency_contact?: Contact;
  pre_authorized_payments?: boolean;
}
```

### DELETE /api/owners/:id
Remove owner (Admin only)

---

## Unit Management

### GET /api/units
List all units
```typescript
// Query Parameters
{
  page?: number;
  limit?: number;
  building_section?: 'tour_sud' | 'tour_nord';
  floor?: number;
  available?: boolean;
}

// Response
{
  data: Unit[];
  total: number;
}
```

### GET /api/units/:id
Get unit details including owner, tenant, assets
```typescript
// Response
{
  id: string;
  unit_number: string;
  building_section: string;
  floor: number;
  ownership_percentage: number;
  owner: Owner;
  tenant?: Tenant;
  parking_spaces: ParkingSpace[];
  lockers: Locker[];
  renovations: UnitRenovation[];
  service_requests: ServiceRequest[];
}
```

### POST /api/units
Create new unit (Admin only)

### PATCH /api/units/:id
Update unit information

### GET /api/units/:id/financial-summary
Get unit's financial overview
```typescript
// Response
{
  unit_id: string;
  outstanding_balance: number;
  paid_this_year: number;
  upcoming_charges: InvoicePreview[];
  payment_history: Payment[];
}
```

---

## Financial Management

### GET /api/accounts-receivable
List all receivables
```typescript
// Query Parameters
{
  unit_id?: string;
  status?: 'pending' | 'paid' | 'overdue';
  from_date?: string;
  to_date?: string;
  invoice_type?: string;
}

// Response
{
  data: AccountReceivable[];
  total_amount: number;
  outstanding_amount: number;
}
```

### POST /api/accounts-receivable
Create new invoice
```typescript
// Request
{
  unit_id: string;
  invoice_type: string;
  amount: number;
  due_date: string;
  description: string;
}
```

### POST /api/accounts-receivable/:id/payment
Record payment
```typescript
// Request
{
  amount: number;
  payment_method: string;
  payment_date: string;
  reference: string;
}
```

### GET /api/accounts-payable
List all payables
```typescript
// Query Parameters
{
  fund_type?: 'fag' | 'faa' | 'fdp';
  status?: 'pending_approval' | 'approved' | 'paid';
  vendor?: string;
}
```

### POST /api/accounts-payable
Create new payable
```typescript
// Request
{
  fund_type: 'fag' | 'faa' | 'fdp';
  vendor_name: string;
  invoice_number: string;
  invoice_date: string;
  due_date: string;
  amount: number;
  tax_amount: number;
  description: string;
  document_url: string;
}
```

### POST /api/accounts-payable/:id/approve
Approve payable (Board member only)

### POST /api/accounts-payable/:id/pay
Mark as paid (Admin only)

### GET /api/budgets
Get budget data
```typescript
// Query Parameters
{
  fiscal_year: number;
  fund_type?: 'fag' | 'faa' | 'fdp';
}

// Response
{
  fiscal_year: number;
  fund_type: string;
  categories: {
    category: string;
    budgeted: number;
    actual: number;
    variance: number;
    items: BudgetItem[];
  }[];
  total_budgeted: number;
  total_actual: number;
  total_variance: number;
}
```

### POST /api/budgets
Create budget (Admin only)

### GET /api/treasury/forecast
Get treasury forecast
```typescript
// Query Parameters
{
  months?: number; // Default 18
}

// Response
{
  current_balance: number;
  forecast: {
    month: string;
    projected_balance: number;
    expected_income: number;
    expected_expenses: number;
  }[];
}
```

---

## Service Requests

### GET /api/service-requests
List service requests
```typescript
// Query Parameters
{
  status?: string;
  priority?: string;
  assigned_to?: string;
  unit_id?: string;
  from_date?: string;
  to_date?: string;
}

// Response
{
  data: ServiceRequest[];
  total: number;
}
```

### POST /api/service-requests
Create service request
```typescript
// Request
{
  unit_id: string;
  request_type: string;
  priority: 'low' | 'medium' | 'high' | 'urgent';
  description: string;
  location_details: string;
  photos?: string[];
}
```

### PATCH /api/service-requests/:id
Update service request

### POST /api/service-requests/:id/assign
Assign to employee
```typescript
// Request
{
  assigned_to: string; // user_id
}
```

### POST /api/service-requests/:id/complete
Mark as completed
```typescript
// Request
{
  resolution_notes: string;
  cost?: number;
  fund_charged?: 'fag' | 'faa' | 'fdp' | 'owner_responsibility';
}
```

---

## Claims Management (FAA)

### GET /api/claims
List all claims
```typescript
// Query Parameters
{
  status?: string;
  responsible_unit?: string;
  from_date?: string;
  to_date?: string;
}
```

### POST /api/claims
Create new claim
```typescript
// Request
{
  incident_date: string;
  responsible_unit_id?: string;
  affected_unit_ids: string[];
  claim_type: string;
  description: string;
  photos?: string[];
}
```

### GET /api/claims/:id
Get claim details with full history

### PATCH /api/claims/:id
Update claim

### POST /api/claims/:id/communications
Add communication log entry
```typescript
// Request
{
  communication_type: 'email' | 'phone' | 'letter';
  direction: 'inbound' | 'outbound';
  party: string;
  summary: string;
  document_url?: string;
}
```

### POST /api/claims/:id/expenses
Add expense to claim
```typescript
// Request
{
  expense_type: 'internal_labor' | 'external';
  amount: number;
  description: string;
  invoice_url?: string;
}
```

### POST /api/claims/:id/close
Close claim

---

## Project Management (FDP)

### GET /api/projects
List all projects
```typescript
// Query Parameters
{
  status?: string;
  fiscal_year?: number;
  priority?: string;
}
```

### POST /api/projects
Create new project
```typescript
// Request
{
  project_name: string;
  project_code: string;
  description: string;
  planned_start_date: string;
  planned_end_date: string;
  budgeted_cost: number;
  priority: 'low' | 'medium' | 'high' | 'critical';
  based_on_quinquennial_report: boolean;
  quinquennial_report_year?: number;
}
```

### GET /api/projects/:id
Get project details with bids and expenses

### POST /api/projects/:id/bids
Submit project bid
```typescript
// Request
{
  vendor_name: string;
  contact_info: Contact;
  bid_amount: number;
  bid_document_url: string;
  notes?: string;
}
```

### POST /api/projects/:id/bids/:bid_id/select
Select winning bid

### POST /api/projects/:id/expenses
Add project expense
```typescript
// Request
{
  description: string;
  amount: number;
  invoice_url: string;
  payment_date: string;
}
```

---

## Maintenance (FAG)

### GET /api/maintenance
List maintenance tasks
```typescript
// Query Parameters
{
  maintenance_type?: 'preventive' | 'corrective' | 'emergency';
  status?: string;
  assigned_to?: string;
  from_date?: string;
  to_date?: string;
}
```

### POST /api/maintenance
Create maintenance task
```typescript
// Request
{
  maintenance_type: 'preventive' | 'corrective' | 'emergency';
  asset_type: string;
  asset_id: string;
  description: string;
  scheduled_date: string;
  assigned_to?: string;
  recurrence?: string; // cron expression
}
```

### GET /api/maintenance/calendar
Get maintenance calendar
```typescript
// Query Parameters
{
  from_date: string;
  to_date: string;
}

// Response
{
  events: CalendarEvent[];
}
```

### POST /api/maintenance/:id/complete
Complete maintenance task
```typescript
// Request
{
  completed_date: string;
  cost?: number;
  vendor?: string;
  notes: string;
  photos?: string[];
}
```

---

## Documents

### GET /api/documents
List documents
```typescript
// Query Parameters
{
  category?: string;
  subcategory?: string;
  fiscal_year?:
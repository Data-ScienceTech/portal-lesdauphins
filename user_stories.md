# User Stories - Dauphins Condo ERP

## Owner (Copropriétaire) Stories

### Profile Management
**US-O-001**: As an owner, I want to view and update my contact information so that the administration can reach me when needed.
- Acceptance Criteria:
  - Can view current email, phone, mailing address
  - Can update contact information
  - Receive confirmation of updates
  - System sends quarterly reminders to verify information

**US-O-002**: As an owner, I want to upload my pre-authorized payment authorization document so that my monthly fees are automatically deducted.
- Acceptance Criteria:
  - Can upload PDF document
  - Document is securely stored
  - Admin receives notification for verification
  - Payment method is updated after verification

**US-O-003**: As an owner, I want to view all assets associated with my unit (parking, lockers) so that I can manage them effectively.
- Acceptance Criteria:
  - See all parking spaces with vehicle details
  - See all lockers and their locations
  - Can update vehicle plate numbers
  - Can view rental contracts for additional lockers

### Financial Management
**US-O-004**: As an owner, I want to view all my invoices and payment history so that I can track my financial obligations.
- Acceptance Criteria:
  - See list of all invoices (paid and unpaid)
  - View breakdown by fund type (FAG, FAA, FDP)
  - Download invoice PDFs
  - See payment history with dates and methods

**US-O-005**: As an owner, I want to make online payments for my invoices so that I can pay conveniently.
- Acceptance Criteria:
  - Select one or multiple invoices to pay
  - Enter payment information securely
  - Receive payment confirmation
  - Invoice marked as paid immediately

**US-O-006**: As an owner, I want to see my outstanding balance and upcoming charges so that I can budget accordingly.
- Acceptance Criteria:
  - Dashboard shows current balance
  - View upcoming monthly charges
  - See breakdown by charge type
  - Export financial summary

### Service Requests
**US-O-007**: As an owner, I want to submit a service request with photos so that maintenance issues can be addressed quickly.
- Acceptance Criteria:
  - Fill out service request form
  - Select request type and priority
  - Upload up to 10 photos
  - Receive confirmation with request number
  - Track request status

**US-O-008**: As an owner, I want to track the status of my service requests so that I know when issues will be resolved.
- Acceptance Criteria:
  - See all my service requests
  - View current status (submitted, assigned, in progress, completed)
  - See who is assigned to the request
  - Receive notifications on status changes
  - View resolution notes when completed

### Documents & Information
**US-O-009**: As an owner, I want to access all condominium documents (governance, financial, etc.) so that I stay informed.
- Acceptance Criteria:
  - Browse documents by category
  - Search documents by keyword
  - Download documents
  - See latest budget and financial statements
  - Access meeting minutes and communications

**US-O-010**: As an owner, I want to upload and track my unit's liability insurance so that I remain compliant.
- Acceptance Criteria:
  - Upload insurance policy document
  - Enter policy details (number, provider, expiry)
  - Receive reminders 60 days before expiry
  - View insurance history

### Communication
**US-O-011**: As an owner, I want to receive important announcements and communications so that I stay informed about building matters.
- Acceptance Criteria:
  - View all announcements in dashboard
  - Receive email notifications
  - Mark communications as read
  - Search past communications

**US-O-012**: As an owner, I want to view upcoming AGA meetings and register my attendance so that I can participate in governance.
- Acceptance Criteria:
  - See meeting date, time, and agenda
  - Register for in-person or virtual attendance
  - Receive meeting reminders
  - Access videoconference link
  - Download meeting materials

---

## Tenant (Locataire) Stories

**US-T-001**: As a tenant, I want to register on the portal with my lease information so that I can access building resources.
- Acceptance Criteria:
  - Create account with unit information
  - Upload lease document
  - Owner approves tenant access
  - Receive welcome email

**US-T-002**: As a tenant, I want to submit service requests for issues in my unit so that problems are addressed.
- Acceptance Criteria:
  - Same as US-O-007 but limited to unit issues
  - Owner receives notification

**US-T-003**: As a tenant, I want to access the resident guide and building rules so that I understand my responsibilities.
- Acceptance Criteria:
  - View resident guide
  - Access building regulations
  - View building amenities information

**US-T-004**: As a tenant, I want to upload my tenant insurance policy so that I comply with lease requirements.
- Acceptance Criteria:
  - Upload insurance document
  - Owner and admin notified
  - Receive renewal reminders

---

## Administrator Stories

### Owner & Unit Management
**US-A-001**: As an administrator, I want to create and manage owner profiles so that all ownership information is accurate.
- Acceptance Criteria:
  - Create new owner profile
  - Link owner to unit
  - Set ownership percentage (quote-part)
  - Manage multiple owners per unit
  - Transfer ownership between owners
  - Archive past owners while maintaining history

**US-A-002**: As an administrator, I want to manage all unit information including parking and lockers so that asset allocation is tracked.
- Acceptance Criteria:
  - Create/edit units
  - Assign parking spaces to units
  - Assign lockers to units
  - Track locker rentals with contracts
  - Generate reports on asset utilization

**US-A-003**: As an administrator, I want to set up automated reminders for owners and tenants so that compliance is maintained.
- Acceptance Criteria:
  - Configure reminder types (insurance, lease, information update)
  - Set reminder schedules
  - View pending reminders
  - Track sent reminders
  - Resend missed reminders

### Financial Operations
**US-A-004**: As an administrator, I want to generate monthly invoices for all units based on quote-parts so that owners are billed correctly.
- Acceptance Criteria:
  - Select invoice type (FAG, FAA, FDP, special assessment)
  - System calculates amounts based on quote-parts
  - Generate invoices for all or selected units
  - Preview invoices before sending
  - Send invoices via email
  - Track invoice status

**US-A-005**: As an administrator, I want to record payments and apply late fees automatically so that financial records are accurate.
- Acceptance Criteria:
  - Record manual payments
  - System auto-applies payments from pre-authorized accounts
  - Automatically calculate late fees after due date
  - Send late payment reminders
  - Generate aging reports

**US-A-006**: As an administrator, I want to manage accounts payable and assign to correct funds so that expenses are tracked properly.
- Acceptance Criteria:
  - Enter vendor invoices
  - Select fund allocation (FAG, FAA, FDP)
  - Upload invoice documents
  - Route to board for approval if needed
  - Track payment status
  - Integration with banking (Access D)

**US-A-007**: As an administrator, I want to track budget vs actual spending by fund so that I can monitor financial health.
- Acceptance Criteria:
  - View budget vs actual for each fund
  - See variance percentages
  - Drill down by category
  - Generate variance reports
  - Alert when categories exceed budget

### Service Request Management
**US-A-008**: As an administrator, I want to manage and assign service requests to employees so that issues are resolved efficiently.
- Acceptance Criteria:
  - View all pending service requests
  - Assign requests to employees
  - Set priority levels
  - Add internal notes
  - Track time to completion
  - Close requests with resolution notes

**US-A-009**: As an administrator, I want to allocate service request costs to the appropriate fund or owner so that expenses are charged correctly.
- Acceptance Criteria:
  - Determine if cost is FAG, FAA, FDP, or owner responsibility
  - Link to accounts payable if external vendor
  - Track internal labor costs
  - Generate cost reports by category

### Document Management
**US-A-010**: As an administrator, I want to upload and organize documents with proper access controls so that information is shared appropriately.
- Acceptance Criteria:
  - Upload multiple documents
  - Set category and subcategory
  - Define visibility (all owners, board only, admin only)
  - Add tags for searchability
  - Version control for updated documents
  - Archive old fiscal year documents

**US-A-011**: As an administrator, I want to manage contracts with renewal reminders so that important agreements don't lapse.
- Acceptance Criteria:
  - Create contract records
  - Upload contract documents
  - Set auto-renewal flags
  - Configure renewal notice periods
  - Receive reminders before expiry
  - Track contract status

### Communication
**US-A-012**: As an administrator, I want to send targeted communications to specific groups of owners/residents so that messages reach the right people.
- Acceptance Criteria:
  - Create communication groups (tour sud/nord, water columns, floors)
  - Compose announcements
  - Select recipient groups
  - Attach documents
  - Schedule send time
  - Track who has read messages

**US-A-013**: As an administrator, I want to archive all email communications searchable by keyword so that I can retrieve past correspondence.
- Acceptance Criteria:
  - Auto-save sent/received emails
  - Link emails to owner profiles
  - Search by keyword, sender, date
  - Generate reports (e.g., "how many emails about pigeons?")
  - Export email threads

### Claims Management (FAA)
**US-A-014**: As an administrator, I want to create and manage insurance claims with full documentation so that incidents are properly tracked.
- Acceptance Criteria:
  - Create claim with incident details
  - Identify responsible and affected units
  - Upload photos and reports
  - Track investigation progress
  - Log communications with insurers
  - Record costs (internal and external)
  - Generate claim reports

### Maintenance (FAG)
**US-A-015**: As an administrator, I want to schedule preventive maintenance with recurring tasks so that building upkeep is maintained.
- Acceptance Criteria:
  - Create maintenance schedules
  - Set recurring tasks (daily, weekly, monthly, yearly)
  - Assign to employees
  - Track completion
  - Record costs
  - Upload photos of completed work
  - Generate maintenance reports

**US-A-016**: As an administrator, I want to manage building assets with maintenance history so that equipment lifecycle is tracked.
- Acceptance Criteria:
  - Create asset inventory
  - Track asset locations
  - Record installation dates
  - Log all maintenance performed
  - Set expected end-of-life dates
  - Alert on equipment nearing replacement
  - Upload asset photos and manuals

---

## Board Member (Conseil d'Administration) Stories

### Financial Oversight
**US-B-001**: As a board member, I want to view comprehensive financial dashboards for all funds so that I can monitor the condo's financial health.
- Acceptance Criteria:
  - See balances for FAG, FAA, FDP
  - View income vs expenses
  - See budget variance
  - Access treasury forecasts (18-month rolling)
  - Compare year-over-year trends

**US-B-002**: As a board member, I want to approve accounts payable before payment so that expenses are properly authorized.
- Acceptance Criteria:
  - View pending approval queue
  - See invoice details and supporting documents
  - Approve or reject with comments
  - Track approval history
  - Receive notifications of new items
  - Set approval thresholds

**US-B-003**: As a board member, I want to review and approve annual budgets by fund so that financial planning is sound.
- Acceptance Criteria:
  - Review proposed budgets
  - Compare to previous years
  - Add comments and adjustments
  - Approve budgets
  - Track budget approval status

### Project Management (FDP)
**US-B-004**: As a board member, I want to manage major renovation projects based on quinquennial reports so that building infrastructure is maintained.
- Acceptance Criteria:
  - View projects from quinquennial report
  - Create project records with budgets
  - Set priority levels
  - Track project timeline
  - Link to long-term financial planning

**US-B-005**: As a board member, I want to evaluate contractor bids for projects so that we select the best value.
- Acceptance Criteria:
  - View all submitted bids
  - Compare bid amounts
  - Review bid documents
  - Add evaluation notes
  - Select winning bid
  - Generate bid comparison reports

**US-B-006**: As a board member, I want to track project progress and spending so that projects stay on budget and schedule.
- Acceptance Criteria:
  - View project status
  - See actual vs budgeted costs
  - Track milestone completion
  - Review change orders
  - Approve additional expenses
  - Access project documentation

### Claims Oversight (FAA)
**US-B-007**: As a board member, I want to review major insurance claims so that I understand liability and costs.
- Acceptance Criteria:
  - View all open claims
  - See claim details and costs
  - Review investigation findings
  - Determine unit responsibility
  - Approve claim resolutions
  - View claims history and trends

### Governance
**US-B-008**: As a board member, I want to schedule and manage AGA meetings with electronic voting so that owner participation is maximized.
- Acceptance Criteria:
  - Schedule meeting date
  - Prepare agenda
  - Upload supporting documents
  - Send meeting notifications
  - Set up virtual meeting link
  - Configure voting items
  - Track attendance
  - Record votes electronically
  - Generate meeting minutes

**US-B-009**: As a board member, I want to review all contracts and approve renewals so that the condo's interests are protected.
- Acceptance Criteria:
  - View all active contracts
  - See contracts nearing expiry
  - Review contract terms
  - Approve/reject renewals
  - Request renegotiations
  - Track contract performance

### Reporting
**US-B-010**: As a board member, I want to generate comprehensive reports for AGAs so that owners are properly informed.
- Acceptance Criteria:
  - Financial statements by fund
  - Budget vs actual comparisons
  - Project status reports
  - Claims summary
  - Maintenance summary
  - Export to PDF
  - Schedule automatic generation

---

## Employee Stories

### Task Management
**US-E-001**: As an employee, I want to view my assigned service requests and maintenance tasks so that I know what work to complete.
- Acceptance Criteria:
  - See list of assigned tasks
  - View task details and location
  - See priority levels
  - Access photos from owners
  - View work history for same unit

**US-E-002**: As an employee, I want to update service request status and add notes so that everyone knows the progress.
- Acceptance Criteria:
  - Mark task as "in progress"
  - Add progress notes
  - Upload photos of work
  - Record time spent
  - Mark task as complete
  - Add resolution details

**US-E-003**: As an employee, I want to view my maintenance schedule so that I can plan my work.
- Acceptance Criteria:
  - Calendar view of scheduled tasks
  - Filter by maintenance type
  - See recurring tasks
  - Mark tasks as complete
  - Request rescheduling if needed

**US-E-004**: As an employee, I want to record costs and materials used so that expenses are tracked accurately.
- Acceptance Criteria:
  - Enter labor hours
  - Record materials used
  - Upload receipts
  - Link to vendor invoices
  - System calculates total cost

### Communication
**US-E-005**: As an employee, I want to communicate with administrators and other team members so that we coordinate work effectively.
- Acceptance Criteria:
  - Send internal messages
  - Receive task assignments
  - Get notifications of urgent requests
  - View team communication history

---

## Super Admin Stories

**US-SA-001**: As a super admin, I want to manage user roles and permissions so that access is properly controlled.
- Acceptance Criteria:
  - Create user accounts
  - Assign/change user roles
  - Deactivate users
  - View audit logs of user actions
  - Reset passwords

**US-SA-002**: As a super admin, I want to configure system settings so that the application works according to our needs.
- Acceptance Criteria:
  - Set fiscal year dates
  - Configure late fee percentages
  - Set reminder schedules
  - Configure email templates
  - Manage communication groups
  - Set approval thresholds

**US-SA-003**: As a super admin, I want to manage database backups and system health so that data is protected.
- Acceptance Criteria:
  - View backup status
  - Trigger manual backups
  - View system health metrics
  - Monitor storage usage
  - View error logs

**US-SA-004**: As a super admin, I want to import/export data for migrations so that we can maintain data integrity.
- Acceptance Criteria:
  - Export all data to CSV/Excel
  - Import owner data
  - Import financial data
  - Validate imported data
  - View import errors
  - Rollback imports if needed

---

## Cross-Functional Stories

### Automated Reminders
**US-X-001**: The system should automatically send insurance expiry reminders 60 days before expiration so that policies remain current.
- Acceptance Criteria:
  - Check insurance expiry dates daily
  - Send email 60 days before expiry
  - Send follow-up at 30 days
  - Send final reminder at 7 days
  - Log all reminders sent
  - Mark policy as compliant when renewed

**US-X-002**: The system should automatically send lease renewal reminders so that tenant status is updated.
- Acceptance Criteria:
  - Check lease end dates
  - Send reminder to owner 90 days before
  - Send reminder to tenant 60 days before
  - Request renewal information
  - Update tenant records

**US-X-003**: The system should automatically calculate and apply late payment fees so that penalties are consistent.
- Acceptance Criteria:
  - Check for unpaid invoices after due date
  - Calculate late fee based on settings
  - Add late fee to account
  - Send notification to owner
  - Log fee application

**US-X-004**: The system should send quarterly reminders to owners to update their contact information so that records stay current.
- Acceptance Criteria:
  - Send reminder every 3 months
  - Provide easy update form
  - Track who has updated
  - Send follow-up to non-responders
  - Log update dates

### Reporting
**US-X-005**: The system should generate monthly financial statements automatically so that financial status is always current.
- Acceptance Criteria:
  - Generate statements on 1st of month
  - Include all funds (FAG, FAA, FDP)
  - Show income, expenses, balances
  - Email to board members
  - Archive in document library

**US-X-006**: The system should provide real-time budget variance alerts so that overspending is caught early.
- Acceptance Criteria:
  - Monitor spending by category
  - Alert when 80% of budget used
  - Alert when budget exceeded
  - Send to administrators and board
  - Show variance in dashboards

### Integration
**US-X-007**: The system should integrate with Access D banking so that transactions are synchronized.
- Acceptance Criteria:
  - Daily sync of transactions
  - Match payments to invoices
  - Update bank balances
  - Flag unmatched transactions
  - Generate reconciliation reports

**US-X-008**: The system should integrate with Employeur D for payroll so that employee costs are tracked.
- Acceptance Criteria:
  - Import payroll data
  - Allocate to FAG or FAA
  - Update financial records
  - Generate payroll reports
  - Track year-to-date costs

---

## Technical Stories

**US-T-001**: The system should maintain complete audit logs so that all changes are traceable.
- Acceptance Criteria:
  - Log all create/update/delete operations
  - Record user, timestamp, IP address
  - Store before/after values
  - Searchable by user, entity, date
  - Cannot be modified or deleted

**US-T-002**: The system should backup all data daily so that information can be recovered.
- Acceptance Criteria:
  - Automated daily backups
  - Store backups securely
  - Test restore process monthly
  - Retain backups for 7 years
  - Alert if backup fails

**US-T-003**: The system should be mobile-responsive so that users can access it from any device.
- Acceptance Criteria:
  - Works on phones, tablets, desktops
  - Touch-friendly interface
  - Optimized for mobile screens
  - Fast load times
  - Offline viewing of downloaded documents

**US-T-004**: The system should send email notifications for key events so that users stay informed.
- Acceptance Criteria:
  - Configurable notification preferences
  - Email templates in French
  - Include relevant links
  - Track delivery status
  - Resend failed emails

**US-T-005**: The system should support file uploads with virus scanning so that documents are safe.
- Acceptance Criteria:
  - Accept PDF, JPG, PNG, XLSX, DOCX
  - Max file size 50MB
  - Virus scan before storage
  - Reject infected files
  - Generate thumbnails for images
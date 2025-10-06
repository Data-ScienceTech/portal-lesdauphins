// ============================================================================
// TYPESCRIPT INTERFACES & TYPES
// Dauphins Condo Management System
// ============================================================================

// ============================================================================
// ENUMS
// ============================================================================

export enum UserRole {
  SUPER_ADMIN = 'super_admin',
  BOARD_MEMBER = 'board_member',
  ADMINISTRATOR = 'administrator',
  EMPLOYEE = 'employee',
  OWNER = 'owner',
  TENANT = 'tenant',
}

export enum FundType {
  FAG = 'fag', // Fonds d'Administration Générale
  FAA = 'faa', // Fonds d'Auto-Assurance
  FDP = 'fdp', // Fonds de Prévoyance
}

export enum InvoiceStatus {
  PENDING = 'pending',
  PAID = 'paid',
  OVERDUE = 'overdue',
  CANCELLED = 'cancelled',
}

export enum ServiceRequestStatus {
  SUBMITTED = 'submitted',
  ASSIGNED = 'assigned',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

export enum Priority {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
  URGENT = 'urgent',
}

export enum ClaimStatus {
  OPEN = 'open',
  INVESTIGATING = 'investigating',
  REPAIR_IN_PROGRESS = 'repair_in_progress',
  CLOSED = 'closed',
}

export enum ProjectStatus {
  PLANNED = 'planned',
  BIDDING = 'bidding',
  APPROVED = 'approved',
  IN_PROGRESS = 'in_progress',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
}

export enum DocumentVisibility {
  ALL_OWNERS = 'all_owners',
  BOARD_ONLY = 'board_only',
  ADMIN_ONLY = 'admin_only',
  PUBLIC_TENANTS = 'public_tenants',
}

export enum MaintenanceType {
  PREVENTIVE = 'preventive',
  CORRECTIVE = 'corrective',
  EMERGENCY = 'emergency',
}

// ============================================================================
// USER & AUTHENTICATION
// ============================================================================

export interface User {
  id: string;
  email: string;
  full_name: string;
  phone?: string;
  role: UserRole;
  created_at: string;
  updated_at: string;
}

export interface AuthSession {
  user: User;
  access_token: string;
  refresh_token: string;
  expires_at: number;
}

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface SignupData extends LoginCredentials {
  full_name: string;
  role?: UserRole;
}

// ============================================================================
// UNITS & OWNERSHIP
// ============================================================================

export interface Unit {
  id: string;
  unit_number: string;
  building_section: string; // "Tour Sud" | "Tour Nord"
  floor: number;
  ownership_percentage: number; // Quote-part
  created_at: string;
  updated_at: string;
}

export interface Address {
  street: string;
  city: string;
  province: string;
  postal_code: string;
  country: string;
}

export interface Contact {
  name: string;
  phone: string;
  email?: string;
  relationship?: string;
}

export interface Owner {
  id: string;
  user_id: string;
  unit_id: string;
  user?: User;
  unit?: Unit;
  primary_residence: boolean;
  mailing_address: Address;
  emergency_contact: Contact;
  ownership_start_date: string;
  ownership_end_date?: string;
  pre_authorized_payments: boolean;
  pre_authorized_payment_doc_url?: string;
  last_info_update_reminder?: string;
  created_at: string;
  updated_at: string;
}

export interface Tenant {
  id: string;
  user_id?: string;
  unit_id: string;
  full_name: string;
  email: string;
  phone: string;
  lease_start_date: string;
  lease_end_date: string;
  lease_document_url: string;
  insurance_document_url?: string;
  insurance_expiry_date?: string;
  renewal_reminder_sent?: string;
  created_at: string;
  updated_at: string;
}

export interface ParkingSpace {
  id: string;
  unit_id: string;
  space_number: string;
  type: 'interior' | 'exterior';
  vehicle_plate?: string;
  vehicle_make_model?: string;
  created_at: string;
  updated_at: string;
}

export interface Locker {
  id: string;
  unit_id: string;
  locker_number: string;
  location: string;
  rental_contract_url?: string;
  rental_amount?: number;
  rental_start_date?: string;
  rental_end_date?: string;
  created_at: string;
  updated_at: string;
}

export interface UnitRenovation {
  id: string;
  unit_id: string;
  renovation_type: string;
  description: string;
  completion_date: string;
  contractor: string;
  cost: number;
  document_urls: string[];
  affects_building_infrastructure: boolean;
  linked_to_fdp: boolean;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// FINANCIAL
// ============================================================================

export interface AccountReceivable {
  id: string;
  unit_id: string;
  invoice_number: string;
  invoice_type: string;
  amount: number;
  due_date: string;
  paid_date?: string;
  payment_method?: string;
  status: InvoiceStatus;
  late_fee_applied: number;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface AccountPayable {
  id: string;
  fund_type: FundType;
  vendor_name: string;
  invoice_number: string;
  invoice_date: string;
  due_date: string;
  amount: number;
  tax_amount: number;
  status: 'pending_approval' | 'approved' | 'paid' | 'cancelled';
  approved_by?: string;
  approved_date?: string;
  paid_date?: string;
  payment_method?: string;
  document_url: string;
  linked_contract_id?: string;
  created_at: string;
  updated_at: string;
}

export interface BankAccount {
  id: string;
  fund_type: FundType;
  account_name: string;
  institution: string;
  account_number: string;
  current_balance: number;
  last_sync_date: string;
  access_d_integration: boolean;
  created_at: string;
  updated_at: string;
}

export interface BudgetItem {
  id: string;
  fiscal_year: number;
  fund_type: FundType;
  category: string;
  subcategory: string;
  budgeted_amount: number;
  actual_amount: number;
  variance: number;
  notes?: string;
  created_at: string;
  updated_at: string;
}

export interface PayrollRecord {
  id: string;
  employee_user_id: string;
  pay_period_start: string;
  pay_period_end: string;
  gross_amount: number;
  deductions: Record<string, number>;
  net_amount: number;
  fund_allocation: Record<FundType, number>;
  paid_date: string;
  employer_d_reference?: string;
  created_at: string;
  updated_at: string;
}

export interface Payment {
  id: string;
  invoice_id: string;
  amount: number;
  payment_date: string;
  payment_method: string;
  reference: string;
  created_at: string;
}

// ============================================================================
// SERVICE REQUESTS & MAINTENANCE
// ============================================================================

export interface ServiceRequest {
  id: string;
  request_number: string;
  unit_id: string;
  requester_id: string;
  request_type: string;
  priority: Priority;
  description: string;
  location_details: string;
  photos: string[];
  status: ServiceRequestStatus;
  assigned_to?: string;
  assigned_date?: string;
  completed_date?: string;
  resolution_notes?: string;
  cost?: number;
  fund_charged?: FundType | 'owner_responsibility';
  created_at: string;
  updated_at: string;
}

export interface MaintenanceTask {
  id: string;
  maintenance_type: MaintenanceType;
  asset_type: string;
  asset_id: string;
  description: string;
  scheduled_date: string;
  completed_date?: string;
  assigned_to?: string;
  cost?: number;
  vendor?: string;
  invoice_url?: string;
  photos: string[];
  maintenance_calendar_recurrence?: string;
  status: 'scheduled' | 'in_progress' | 'completed' | 'cancelled';
  created_at: string;
  updated_at: string;
}

// ============================================================================
// CLAIMS (FAA)
// ============================================================================

export interface Claim {
  id: string;
  claim_number: string;
  incident_date: string;
  reported_date: string;
  responsible_unit_id?: string;
  affected_unit_ids: string[];
  claim_type: string;
  description: string;
  status: ClaimStatus;
  total_cost: number;
  internal_labor_cost: number;
  external_cost: number;
  insurance_payout?: number;
  photos: string[];
  reports: string[];
  expert_reports: string[];
  communications_log: CommunicationLog[];
  assigned_to?: string;
  closed_date?: string;
  created_at: string;
  updated_at: string;
}

export interface CommunicationLog {
  timestamp: string;
  type: 'email' | 'phone' | 'letter';
  direction: 'inbound' | 'outbound';
  party: string;
  summary: string;
  document_url?: string;
}

// ============================================================================
// PROJECTS (FDP)
// ============================================================================

export interface Project {
  id: string;
  project_name: string;
  project_code: string;
  description: string;
  planned_start_date: string;
  planned_end_date: string;
  actual_start_date?: string;
  actual_end_date?: string;
  budgeted_cost: number;
  actual_cost: number;
  status: ProjectStatus;
  priority: Priority;
  based_on_quinquennial_report: boolean;
  quinquennial_report_year?: number;
  project_manager?: string;
  created_at: string;
  updated_at: string;
}

export interface ProjectBid {
  id: string;
  project_id: string;
  vendor_name: string;
  contact_info: Contact;
  bid_amount: number;
  submission_date: string;
  bid_document_url: string;
  status: 'submitted' | 'under_review' | 'accepted' | 'rejected';
  evaluation_notes?: string;
  selected: boolean;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// DOCUMENTS
// ============================================================================

export interface Document {
  id: string;
  category: string;
  subcategory?: string;
  title: string;
  description?: string;
  file_url: string;
  file_type: string;
  file_size: number;
  fiscal_year?: number;
  visibility: DocumentVisibility;
  related_entity_type?: string;
  related_entity_id?: string;
  uploaded_by: string;
  tags: string[];
  version: number;
  created_at: string;
  updated_at: string;
}

export interface Contract {
  id: string;
  contract_type: 'employee' | 'vendor' | 'service' | 'lease' | 'rental';
  party_name: string;
  description: string;
  start_date: string;
  end_date?: string;
  auto_renewal: boolean;
  renewal_notice_days?: number;
  contract_value?: number;
  payment_frequency?: string;
  document_url: string;
  status: 'active' | 'expired' | 'terminated' | 'pending_renewal';
  renewal_reminder_sent?: string;
  assigned_fund?: FundType;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// COMMUNICATIONS
// ============================================================================

export interface Communication {
  id: string;
  communication_type: 'email' | 'internal_message' | 'announcement' | 'circular_letter';
  from_user_id: string;
  to_group?: string;
  to_user_ids: string[];
  subject: string;
  body: string;
  attachments: string[];
  sent_at: string;
  read_by: Record<string, string>; // {user_id: timestamp}
  related_entity_type?: string;
  related_entity_id?: string;
  tags: string[];
  created_at: string;
}

export interface CommunicationGroup {
  id: string;
  group_name: string;
  group_type: 'building_section' | 'water_column' | 'role' | 'custom';
  description: string;
  member_user_ids: string[];
  created_by: string;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// MEETINGS
// ============================================================================

export interface Meeting {
  id: string;
  meeting_date: string;
  meeting_type: 'aga' | 'special' | 'board';
  location: string;
  videoconference_link?: string;
  agenda: string;
  minutes_document_url?: string;
  recording_url?: string;
  attendance_list: AttendanceRecord[];
  voting_results: VotingResult[];
  status: 'scheduled' | 'in_progress' | 'completed' | 'cancelled';
  notification_sent_date?: string;
  created_at: string;
  updated_at: string;
}

export interface AttendanceRecord {
  user_id: string;
  attendance_type: 'in_person' | 'virtual';
  checked_in_at?: string;
}

export interface VotingResult {
  motion_id: string;
  motion_text: string;
  votes_for: number;
  votes_against: number;
  votes_abstain: number;
  result: 'passed' | 'failed';
}

// ============================================================================
// INSURANCE
// ============================================================================

export interface InsurancePolicy {
  id: string;
  entity_type: 'owner' | 'tenant' | 'building';
  entity_id?: string;
  policy_type: 'liability' | 'building' | 'contents';
  policy_number: string;
  provider: string;
  document_url: string;
  start_date: string;
  expiry_date: string;
  renewal_reminder_sent?: string;
  created_at: string;
  updated_at: string;
}

// ============================================================================
// REMINDERS & NOTIFICATIONS
// ============================================================================

export interface AutomatedReminder {
  id: string;
  reminder_type: string;
  entity_type: string;
  entity_id: string;
  scheduled_date: string;
  sent_date?: string;
  recipient_user_ids: string[];
  message_template: string;
  status: 'pending' | 'sent' | 'failed';
  created_at: string;
  updated_at: string;
}

// ============================================================================
// SYSTEM & AUDIT
// ============================================================================

export interface AuditLogEntry {
  id: string;
  user_id: string;
  action: string;
  entity_type: string;
  entity_id: string;
  changes: {
    old: any;
    new: any;
  };
  ip_address: string;
  created_at: string;
}

export interface SystemSettings {
  id: string;
  setting_key: string;
  setting_value: any;
  description: string;
  updated_by: string;
  updated_at: string;
}

export interface Report {
  id: string;
  report_name: string;
  report_type: 'financial' | 'maintenance' | 'inventory' | 'custom';
  parameters: Record<string, any>;
  generated_by: string;
  file_url: string;
  created_at: string;
}

// ============================================================================
// API RESPONSE TYPES
// ============================================================================

export interface ApiResponse<T> {
  data: T;
  error?: ApiError;
}

export interface ApiError {
  code: string;
  message: string;
  details?: any;
  timestamp: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    total_pages: number;
    has_next: boolean
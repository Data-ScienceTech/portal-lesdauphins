-- ============================================================================
-- SUPABASE ROW LEVEL SECURITY (RLS) POLICIES
-- Dauphins Condo Management System
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE units ENABLE ROW LEVEL SECURITY;
ALTER TABLE owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE parking_spaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE lockers ENABLE ROW LEVEL SECURITY;
ALTER TABLE unit_renovations ENABLE ROW LEVEL SECURITY;
ALTER TABLE insurance_policies ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts_receivable ENABLE ROW LEVEL SECURITY;
ALTER TABLE accounts_payable ENABLE ROW LEVEL SECURITY;
ALTER TABLE bank_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE budget_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE payroll ENABLE ROW LEVEL SECURITY;
ALTER TABLE fag_maintenance ENABLE ROW LEVEL SECURITY;
ALTER TABLE faa_claims ENABLE ROW LEVEL SECURITY;
ALTER TABLE fdp_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE fdp_project_bids ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE communications ENABLE ROW LEVEL SECURITY;
ALTER TABLE communication_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE aga_meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE automated_reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_settings ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Get current user's role
CREATE OR REPLACE FUNCTION get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM users WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is admin or board member
CREATE OR REPLACE FUNCTION is_admin_or_board()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid() 
    AND role IN ('super_admin', 'board_member', 'administrator')
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is super admin
CREATE OR REPLACE FUNCTION is_super_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM users 
    WHERE id = auth.uid() 
    AND role = 'super_admin'
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Get user's unit_id as owner
CREATE OR REPLACE FUNCTION get_user_unit_id()
RETURNS UUID AS $$
  SELECT unit_id FROM owners WHERE user_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Get user's unit_id as tenant
CREATE OR REPLACE FUNCTION get_user_tenant_unit_id()
RETURNS UUID AS $$
  SELECT unit_id FROM tenants WHERE user_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is owner of specific unit
CREATE OR REPLACE FUNCTION is_unit_owner(unit_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM owners 
    WHERE user_id = auth.uid() 
    AND unit_id = unit_uuid
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================================
-- USERS TABLE POLICIES
-- ============================================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (id = auth.uid());

-- Admin and board can view all users
CREATE POLICY "Admin can view all users"
ON users FOR SELECT
USING (is_admin_or_board());

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON users FOR UPDATE
USING (id = auth.uid());

-- Super admin can do everything
CREATE POLICY "Super admin full access"
ON users FOR ALL
USING (is_super_admin());

-- ============================================================================
-- UNITS TABLE POLICIES
-- ============================================================================

-- Owners can view their own unit
CREATE POLICY "Owners can view own unit"
ON units FOR SELECT
USING (
  id = get_user_unit_id() OR 
  id = get_user_tenant_unit_id() OR
  is_admin_or_board()
);

-- Admin can manage all units
CREATE POLICY "Admin can manage units"
ON units FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- OWNERS TABLE POLICIES
-- ============================================================================

-- Owners can view their own record
CREATE POLICY "Owners can view own record"
ON owners FOR SELECT
USING (user_id = auth.uid() OR is_admin_or_board());

-- Admin can manage all owners
CREATE POLICY "Admin can manage owners"
ON owners FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- TENANTS TABLE POLICIES
-- ============================================================================

-- Tenants can view their own record
CREATE POLICY "Tenants can view own record"
ON tenants FOR SELECT
USING (user_id = auth.uid() OR is_admin_or_board());

-- Unit owners can view tenants in their unit
CREATE POLICY "Owners can view their unit tenants"
ON tenants FOR SELECT
USING (is_unit_owner(unit_id));

-- Admin can manage all tenants
CREATE POLICY "Admin can manage tenants"
ON tenants FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- PARKING & LOCKERS POLICIES
-- ============================================================================

-- Owners can view their parking/lockers
CREATE POLICY "Owners can view own parking"
ON parking_spaces FOR SELECT
USING (is_unit_owner(unit_id) OR is_admin_or_board());

CREATE POLICY "Owners can view own lockers"
ON lockers FOR SELECT
USING (is_unit_owner(unit_id) OR is_admin_or_board());

-- Admin can manage parking/lockers
CREATE POLICY "Admin can manage parking"
ON parking_spaces FOR ALL
USING (is_admin_or_board());

CREATE POLICY "Admin can manage lockers"
ON lockers FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- RENOVATIONS POLICIES
-- ============================================================================

-- Owners can view renovations for their unit
CREATE POLICY "Owners can view own renovations"
ON unit_renovations FOR SELECT
USING (is_unit_owner(unit_id) OR is_admin_or_board());

-- Admin can manage renovations
CREATE POLICY "Admin can manage renovations"
ON unit_renovations FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- INSURANCE POLICIES
-- ============================================================================

-- Owners can view their own insurance
CREATE POLICY "Owners can view own insurance"
ON insurance_policies FOR SELECT
USING (
  (entity_type = 'owner' AND entity_id IN (
    SELECT id FROM owners WHERE user_id = auth.uid()
  )) OR
  entity_type = 'building' OR
  is_admin_or_board()
);

-- Admin can manage insurance
CREATE POLICY "Admin can manage insurance"
ON insurance_policies FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- FINANCIAL POLICIES - ACCOUNTS RECEIVABLE
-- ============================================================================

-- Owners can view their own invoices
CREATE POLICY "Owners can view own invoices"
ON accounts_receivable FOR SELECT
USING (is_unit_owner(unit_id) OR is_admin_or_board());

-- Admin can manage invoices
CREATE POLICY "Admin can manage invoices"
ON accounts_receivable FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- FINANCIAL POLICIES - ACCOUNTS PAYABLE
-- ============================================================================

-- Board and admin can view accounts payable
CREATE POLICY "Board can view accounts payable"
ON accounts_payable FOR SELECT
USING (is_admin_or_board());

-- Only admin can create/update
CREATE POLICY "Admin can manage accounts payable"
ON accounts_payable FOR ALL
USING (
  get_user_role() IN ('super_admin', 'administrator')
);

-- Board members can approve
CREATE POLICY "Board can approve payables"
ON accounts_payable FOR UPDATE
USING (
  get_user_role() = 'board_member' AND
  status = 'pending_approval'
);

-- ============================================================================
-- BANK ACCOUNTS POLICIES
-- ============================================================================

-- Only admin and board can view bank accounts
CREATE POLICY "Board can view bank accounts"
ON bank_accounts FOR SELECT
USING (is_admin_or_board());

-- Only super admin can manage
CREATE POLICY "Super admin can manage bank accounts"
ON bank_accounts FOR ALL
USING (is_super_admin());

-- ============================================================================
-- BUDGET POLICIES
-- ============================================================================

-- All authenticated users can view budgets
CREATE POLICY "Users can view budgets"
ON budget_items FOR SELECT
USING (auth.uid() IS NOT NULL);

-- Only admin can manage budgets
CREATE POLICY "Admin can manage budgets"
ON budget_items FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- PAYROLL POLICIES
-- ============================================================================

-- Employees can view their own payroll
CREATE POLICY "Employees can view own payroll"
ON payroll FOR SELECT
USING (employee_user_id = auth.uid() OR is_admin_or_board());

-- Only admin can manage payroll
CREATE POLICY "Admin can manage payroll"
ON payroll FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- FAG MAINTENANCE POLICIES
-- ============================================================================

-- Employees can view assigned maintenance
CREATE POLICY "Employees can view assigned maintenance"
ON fag_maintenance FOR SELECT
USING (
  assigned_to = auth.uid() OR
  get_user_role() IN ('administrator', 'board_member', 'super_admin')
);

-- Admin and employees can create/update maintenance
CREATE POLICY "Staff can manage maintenance"
ON fag_maintenance FOR ALL
USING (
  get_user_role() IN ('super_admin', 'administrator', 'employee')
);

-- ============================================================================
-- FAA CLAIMS POLICIES
-- ============================================================================

-- Owners can view claims affecting their unit
CREATE POLICY "Owners can view relevant claims"
ON faa_claims FOR SELECT
USING (
  is_unit_owner(responsible_unit_id) OR
  get_user_unit_id() = ANY(affected_unit_ids) OR
  is_admin_or_board()
);

-- Admin can manage claims
CREATE POLICY "Admin can manage claims"
ON faa_claims FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- FDP PROJECTS POLICIES
-- ============================================================================

-- All users can view projects
CREATE POLICY "Users can view projects"
ON fdp_projects FOR SELECT
USING (auth.uid() IS NOT NULL);

-- Admin and board can manage projects
CREATE POLICY "Admin can manage projects"
ON fdp_projects FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- FDP BIDS POLICIES
-- ============================================================================

-- Board and admin can view bids
CREATE POLICY "Board can view bids"
ON fdp_project_bids FOR SELECT
USING (is_admin_or_board());

-- Admin can manage bids
CREATE POLICY "Admin can manage bids"
ON fdp_project_bids FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- DOCUMENTS POLICIES
-- ============================================================================

-- Users can view documents based on visibility
CREATE POLICY "Users can view permitted documents"
ON documents FOR SELECT
USING (
  CASE visibility
    WHEN 'all_owners' THEN get_user_role() IN ('owner', 'board_member', 'administrator', 'super_admin')
    WHEN 'public_tenants' THEN auth.uid() IS NOT NULL
    WHEN 'board_only' THEN get_user_role() IN ('board_member', 'super_admin')
    WHEN 'admin_only' THEN get_user_role() IN ('administrator', 'super_admin')
    ELSE is_super_admin()
  END
);

-- Admin can manage documents
CREATE POLICY "Admin can manage documents"
ON documents FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- CONTRACTS POLICIES
-- ============================================================================

-- Board and admin can view contracts
CREATE POLICY "Board can view contracts"
ON contracts FOR SELECT
USING (is_admin_or_board());

-- Admin can manage contracts
CREATE POLICY "Admin can manage contracts"
ON contracts FOR ALL
USING (is_admin_or_board());

-- Employees can view service contracts
CREATE POLICY "Employees can view service contracts"
ON contracts FOR SELECT
USING (
  contract_type = 'service' AND
  get_user_role() = 'employee'
);

-- ============================================================================
-- SERVICE REQUESTS POLICIES
-- ============================================================================

-- Users can view their own service requests
CREATE POLICY "Users can view own service requests"
ON service_requests FOR SELECT
USING (
  requester_id = auth.uid() OR
  is_unit_owner(unit_id) OR
  assigned_to = auth.uid() OR
  is_admin_or_board()
);

-- Users can create service requests for their unit
CREATE POLICY "Users can create service requests"
ON service_requests FOR INSERT
WITH CHECK (
  is_unit_owner(unit_id) OR
  get_user_tenant_unit_id() = unit_id
);

-- Employees can update assigned requests
CREATE POLICY "Employees can update assigned requests"
ON service_requests FOR UPDATE
USING (assigned_to = auth.uid() OR is_admin_or_board());

-- Admin can manage all requests
CREATE POLICY "Admin can manage service requests"
ON service_requests FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- COMMUNICATIONS POLICIES
-- ============================================================================

-- Users can view communications sent to them
CREATE POLICY "Users can view own communications"
ON communications FOR SELECT
USING (
  from_user_id = auth.uid() OR
  auth.uid() = ANY(to_user_ids) OR
  is_admin_or_board()
);

-- Users can send communications
CREATE POLICY "Users can send communications"
ON communications FOR INSERT
WITH CHECK (from_user_id = auth.uid());

-- Admin can manage all communications
CREATE POLICY "Admin can manage communications"
ON communications FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- COMMUNICATION GROUPS POLICIES
-- ============================================================================

-- Users can view groups they belong to
CREATE POLICY "Users can view own groups"
ON communication_groups FOR SELECT
USING (
  auth.uid() = ANY(member_user_ids) OR
  is_admin_or_board()
);

-- Admin can manage groups
CREATE POLICY "Admin can manage groups"
ON communication_groups FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- AGA MEETINGS POLICIES
-- ============================================================================

-- All owners can view meetings
CREATE POLICY "Owners can view meetings"
ON aga_meetings FOR SELECT
USING (
  get_user_role() IN ('owner', 'board_member', 'administrator', 'super_admin')
);

-- Admin can manage meetings
CREATE POLICY "Admin can manage meetings"
ON aga_meetings FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- AUTOMATED REMINDERS POLICIES
-- ============================================================================

-- Users can view their own reminders
CREATE POLICY "Users can view own reminders"
ON automated_reminders FOR SELECT
USING (
  auth.uid() = ANY(recipient_user_ids) OR
  is_admin_or_board()
);

-- Admin can manage reminders
CREATE POLICY "Admin can manage reminders"
ON automated_reminders FOR ALL
USING (is_admin_or_board());

-- ============================================================================
-- AUDIT LOG POLICIES
-- ============================================================================

-- Users can view their own audit logs
CREATE POLICY "Users can view own audit logs"
ON audit_log FOR SELECT
USING (user_id = auth.uid() OR is_admin_or_board());

-- Only system can insert audit logs
CREATE POLICY "System can insert audit logs"
ON audit_log FOR INSERT
WITH CHECK (true);

-- Super admin can view all
CREATE POLICY "Super admin can view all audit logs"
ON audit_log FOR SELECT
USING (is_super_admin());

-- ============================================================================
-- REPORTS POLICIES
-- ============================================================================

-- Users can view their own generated reports
CREATE POLICY "Users can view own reports"
ON reports FOR SELECT
USING (generated_by = auth.uid() OR is_admin_or_board());

-- Users can generate reports
CREATE POLICY "Users can generate reports"
ON reports FOR INSERT
WITH CHECK (generated_by = auth.uid());

-- ============================================================================
-- SYSTEM SETTINGS POLICIES
-- ============================================================================

-- All users can view system settings
CREATE POLICY "Users can view settings"
ON system_settings FOR SELECT
USING (auth.uid() IS NOT NULL);

-- Only super admin can modify settings
CREATE POLICY "Super admin can manage settings"
ON system_settings FOR ALL
USING (is_super_admin());

-- ============================================================================
-- STORAGE POLICIES (Supabase Storage Buckets)
-- ============================================================================

-- Documents bucket
CREATE POLICY "Users can view documents based on role"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'documents' AND
  auth.uid() IS NOT NULL
);

CREATE POLICY "Admin can upload documents"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'documents' AND
  is_admin_or_board()
);

-- Photos bucket
CREATE POLICY "Users can view photos"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'photos' AND
  auth.uid() IS NOT NULL
);

CREATE POLICY "Authenticated users can upload photos"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'photos' AND
  auth.uid() IS NOT NULL
);

-- ============================================================================
-- TRIGGERS FOR AUDIT LOGGING
-- ============================================================================

CREATE OR REPLACE FUNCTION audit_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (
    user_id,
    action,
    entity_type,
    entity_id,
    changes,
    ip_address
  ) VALUES (
    auth.uid(),
    TG_OP,
    TG_TABLE_NAME,
    COALESCE(NEW.id, OLD.id),
    jsonb_build_object(
      'old', to_jsonb(OLD),
      'new', to_jsonb(NEW)
    ),
    current_setting('request.headers', true)::json->>'x-forwarded-for'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Apply audit trigger to sensitive tables
CREATE TRIGGER audit_accounts_payable
AFTER INSERT OR UPDATE OR DELETE ON accounts_payable
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();

CREATE TRIGGER audit_bank_accounts
AFTER INSERT OR UPDATE OR DELETE ON bank_accounts
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();

CREATE TRIGGER audit_budget_items
AFTER INSERT OR UPDATE OR DELETE ON budget_items
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();

CREATE TRIGGER audit_system_settings
AFTER INSERT OR UPDATE OR DELETE ON system_settings
FOR EACH ROW EXECUTE FUNCTION audit_log_trigger();
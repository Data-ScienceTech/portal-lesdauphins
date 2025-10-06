-- ============================================================================
-- INITIAL DATABASE SETUP - Les Dauphins Portal
-- Run this in Supabase SQL Editor to create essential tables
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'owner' CHECK (role IN ('super_admin', 'board_member', 'administrator', 'employee', 'owner', 'tenant')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Units table
CREATE TABLE IF NOT EXISTS public.units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_number TEXT UNIQUE NOT NULL,
  building_section TEXT NOT NULL CHECK (building_section IN ('Tour Sud', 'Tour Nord')),
  floor INTEGER NOT NULL,
  ownership_percentage DECIMAL(5,4) NOT NULL, -- Quote-part (e.g., 0.0024 = 0.24%)
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Owners table
CREATE TABLE IF NOT EXISTS public.owners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  primary_residence BOOLEAN DEFAULT true,
  mailing_address JSONB, -- {street, city, province, postal_code, country}
  emergency_contact JSONB, -- {name, phone, email, relationship}
  ownership_start_date DATE NOT NULL,
  ownership_end_date DATE,
  pre_authorized_payments BOOLEAN DEFAULT false,
  pre_authorized_payment_doc_url TEXT,
  last_info_update_reminder TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, unit_id)
);

-- Accounts Receivable (Invoices)
CREATE TABLE IF NOT EXISTS public.accounts_receivable (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  invoice_number TEXT UNIQUE NOT NULL,
  invoice_type TEXT NOT NULL, -- 'FAG', 'FAA', 'FDP', 'Special Assessment'
  amount DECIMAL(10,2) NOT NULL,
  due_date DATE NOT NULL,
  paid_date DATE,
  payment_method TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue', 'cancelled')),
  late_fee_applied DECIMAL(10,2) DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Service Requests
CREATE TABLE IF NOT EXISTS public.service_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_number TEXT UNIQUE NOT NULL,
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  requester_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  request_type TEXT NOT NULL,
  priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  description TEXT NOT NULL,
  location_details TEXT,
  photos TEXT[], -- Array of URLs
  status TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'assigned', 'in_progress', 'completed', 'cancelled')),
  assigned_to UUID REFERENCES public.users(id),
  assigned_date TIMESTAMPTZ,
  completed_date TIMESTAMPTZ,
  resolution_notes TEXT,
  cost DECIMAL(10,2),
  fund_charged TEXT, -- 'fag', 'faa', 'fdp', 'owner_responsibility'
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Documents
CREATE TABLE IF NOT EXISTS public.documents (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category TEXT NOT NULL,
  subcategory TEXT,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT NOT NULL,
  file_type TEXT NOT NULL,
  file_size INTEGER NOT NULL,
  fiscal_year INTEGER,
  visibility TEXT NOT NULL DEFAULT 'all_owners' CHECK (visibility IN ('all_owners', 'board_only', 'admin_only', 'public_tenants')),
  related_entity_type TEXT,
  related_entity_id UUID,
  uploaded_by UUID NOT NULL REFERENCES public.users(id),
  tags TEXT[],
  version INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Communications
CREATE TABLE IF NOT EXISTS public.communications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  communication_type TEXT NOT NULL CHECK (communication_type IN ('email', 'internal_message', 'announcement', 'circular_letter')),
  from_user_id UUID NOT NULL REFERENCES public.users(id),
  to_group TEXT,
  to_user_ids UUID[],
  subject TEXT NOT NULL,
  body TEXT NOT NULL,
  attachments TEXT[],
  sent_at TIMESTAMPTZ DEFAULT NOW(),
  read_by JSONB DEFAULT '{}', -- {user_id: timestamp}
  related_entity_type TEXT,
  related_entity_id UUID,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Parking Spaces
CREATE TABLE IF NOT EXISTS public.parking_spaces (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  space_number TEXT UNIQUE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('interior', 'exterior')),
  vehicle_plate TEXT,
  vehicle_make_model TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Lockers
CREATE TABLE IF NOT EXISTS public.lockers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  locker_number TEXT UNIQUE NOT NULL,
  location TEXT NOT NULL,
  rental_contract_url TEXT,
  rental_amount DECIMAL(10,2),
  rental_start_date DATE,
  rental_end_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.owners ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.accounts_receivable ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.service_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.communications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parking_spaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lockers ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Get current user's role
CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM public.users WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is admin or board
CREATE OR REPLACE FUNCTION public.is_admin_or_board()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users 
    WHERE id = auth.uid() 
    AND role IN ('super_admin', 'board_member', 'administrator')
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- Get user's unit_id as owner
CREATE OR REPLACE FUNCTION public.get_user_unit_id()
RETURNS UUID AS $$
  SELECT unit_id FROM public.owners WHERE user_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user is owner of specific unit
CREATE OR REPLACE FUNCTION public.is_unit_owner(unit_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.owners 
    WHERE user_id = auth.uid() 
    AND unit_id = unit_uuid
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================================
-- ROW LEVEL SECURITY POLICIES
-- ============================================================================

-- USERS POLICIES
CREATE POLICY "Users can view own profile"
  ON public.users FOR SELECT
  USING (id = auth.uid());

CREATE POLICY "Admin can view all users"
  ON public.users FOR SELECT
  USING (is_admin_or_board());

CREATE POLICY "Users can update own profile"
  ON public.users FOR UPDATE
  USING (id = auth.uid());

-- UNITS POLICIES
CREATE POLICY "Owners can view own unit"
  ON public.units FOR SELECT
  USING (id = get_user_unit_id() OR is_admin_or_board());

CREATE POLICY "Admin can manage units"
  ON public.units FOR ALL
  USING (is_admin_or_board());

-- OWNERS POLICIES
CREATE POLICY "Owners can view own record"
  ON public.owners FOR SELECT
  USING (user_id = auth.uid() OR is_admin_or_board());

CREATE POLICY "Admin can manage owners"
  ON public.owners FOR ALL
  USING (is_admin_or_board());

-- ACCOUNTS RECEIVABLE POLICIES
CREATE POLICY "Owners can view own invoices"
  ON public.accounts_receivable FOR SELECT
  USING (is_unit_owner(unit_id) OR is_admin_or_board());

CREATE POLICY "Admin can manage invoices"
  ON public.accounts_receivable FOR ALL
  USING (is_admin_or_board());

-- SERVICE REQUESTS POLICIES
CREATE POLICY "Users can view own service requests"
  ON public.service_requests FOR SELECT
  USING (
    requester_id = auth.uid() OR
    is_unit_owner(unit_id) OR
    assigned_to = auth.uid() OR
    is_admin_or_board()
  );

CREATE POLICY "Users can create service requests"
  ON public.service_requests FOR INSERT
  WITH CHECK (is_unit_owner(unit_id));

CREATE POLICY "Employees can update assigned requests"
  ON public.service_requests FOR UPDATE
  USING (assigned_to = auth.uid() OR is_admin_or_board());

CREATE POLICY "Admin can manage service requests"
  ON public.service_requests FOR ALL
  USING (is_admin_or_board());

-- DOCUMENTS POLICIES
CREATE POLICY "Users can view permitted documents"
  ON public.documents FOR SELECT
  USING (
    CASE visibility
      WHEN 'all_owners' THEN get_user_role() IN ('owner', 'board_member', 'administrator', 'super_admin')
      WHEN 'public_tenants' THEN auth.uid() IS NOT NULL
      WHEN 'board_only' THEN get_user_role() IN ('board_member', 'super_admin')
      WHEN 'admin_only' THEN get_user_role() IN ('administrator', 'super_admin')
      ELSE is_admin_or_board()
    END
  );

CREATE POLICY "Admin can manage documents"
  ON public.documents FOR ALL
  USING (is_admin_or_board());

-- COMMUNICATIONS POLICIES
CREATE POLICY "Users can view own communications"
  ON public.communications FOR SELECT
  USING (
    from_user_id = auth.uid() OR
    auth.uid() = ANY(to_user_ids) OR
    is_admin_or_board()
  );

CREATE POLICY "Users can send communications"
  ON public.communications FOR INSERT
  WITH CHECK (from_user_id = auth.uid());

-- PARKING & LOCKERS POLICIES
CREATE POLICY "Owners can view own parking"
  ON public.parking_spaces FOR SELECT
  USING (is_unit_owner(unit_id) OR is_admin_or_board());

CREATE POLICY "Admin can manage parking"
  ON public.parking_spaces FOR ALL
  USING (is_admin_or_board());

CREATE POLICY "Owners can view own lockers"
  ON public.lockers FOR SELECT
  USING (is_unit_owner(unit_id) OR is_admin_or_board());

CREATE POLICY "Admin can manage lockers"
  ON public.lockers FOR ALL
  USING (is_admin_or_board());

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX idx_users_email ON public.users(email);
CREATE INDEX idx_users_role ON public.users(role);
CREATE INDEX idx_units_number ON public.units(unit_number);
CREATE INDEX idx_owners_user_id ON public.owners(user_id);
CREATE INDEX idx_owners_unit_id ON public.owners(unit_id);
CREATE INDEX idx_accounts_receivable_unit_id ON public.accounts_receivable(unit_id);
CREATE INDEX idx_accounts_receivable_status ON public.accounts_receivable(status);
CREATE INDEX idx_service_requests_unit_id ON public.service_requests(unit_id);
CREATE INDEX idx_service_requests_status ON public.service_requests(status);
CREATE INDEX idx_service_requests_assigned_to ON public.service_requests(assigned_to);
CREATE INDEX idx_documents_category ON public.documents(category);
CREATE INDEX idx_documents_visibility ON public.documents(visibility);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================================================

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON public.units
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_owners_updated_at BEFORE UPDATE ON public.owners
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_accounts_receivable_updated_at BEFORE UPDATE ON public.accounts_receivable
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_service_requests_updated_at BEFORE UPDATE ON public.service_requests
  FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Database setup complete!';
  RAISE NOTICE 'Next steps:';
  RAISE NOTICE '1. Create a test user in Authentication > Users';
  RAISE NOTICE '2. Insert the user into public.users table';
  RAISE NOTICE '3. Create sample units and owners';
END $$;

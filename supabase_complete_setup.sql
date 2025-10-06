-- ============================================================================
-- COMPLETE SETUP - Les Dauphins Portal
-- Run this entire script in Supabase SQL Editor
-- ============================================================================
-- STEP 1: Replace YOUR_AUTH_USER_ID below with your actual test user's UUID
-- Find it in: Supabase Dashboard > Authentication > Users > Copy User ID
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- CREATE TABLES
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone TEXT,
  role TEXT NOT NULL DEFAULT 'owner' CHECK (role IN ('super_admin', 'board_member', 'administrator', 'employee', 'owner', 'tenant')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.units (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_number TEXT UNIQUE NOT NULL,
  building_section TEXT NOT NULL CHECK (building_section IN ('Tour Sud', 'Tour Nord')),
  floor INTEGER NOT NULL,
  ownership_percentage DECIMAL(5,4) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.owners (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  primary_residence BOOLEAN DEFAULT true,
  mailing_address JSONB,
  emergency_contact JSONB,
  ownership_start_date DATE NOT NULL,
  ownership_end_date DATE,
  pre_authorized_payments BOOLEAN DEFAULT false,
  pre_authorized_payment_doc_url TEXT,
  last_info_update_reminder TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, unit_id)
);

CREATE TABLE IF NOT EXISTS public.accounts_receivable (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  invoice_number TEXT UNIQUE NOT NULL,
  invoice_type TEXT NOT NULL,
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

CREATE TABLE IF NOT EXISTS public.service_requests (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  request_number TEXT UNIQUE NOT NULL,
  unit_id UUID NOT NULL REFERENCES public.units(id) ON DELETE CASCADE,
  requester_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  request_type TEXT NOT NULL,
  priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  description TEXT NOT NULL,
  location_details TEXT,
  photos TEXT[],
  status TEXT NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'assigned', 'in_progress', 'completed', 'cancelled')),
  assigned_to UUID REFERENCES public.users(id),
  assigned_date TIMESTAMPTZ,
  completed_date TIMESTAMPTZ,
  resolution_notes TEXT,
  cost DECIMAL(10,2),
  fund_charged TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

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
  read_by JSONB DEFAULT '{}',
  related_entity_type TEXT,
  related_entity_id UUID,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

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
-- ENABLE RLS
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

CREATE OR REPLACE FUNCTION public.get_user_role()
RETURNS TEXT AS $$
  SELECT role FROM public.users WHERE id = auth.uid();
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_admin_or_board()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users 
    WHERE id = auth.uid() 
    AND role IN ('super_admin', 'board_member', 'administrator')
  );
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.get_user_unit_id()
RETURNS UUID AS $$
  SELECT unit_id FROM public.owners WHERE user_id = auth.uid() LIMIT 1;
$$ LANGUAGE sql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION public.is_unit_owner(unit_uuid UUID)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.owners 
    WHERE user_id = auth.uid() 
    AND unit_id = unit_uuid
  );
$$ LANGUAGE sql SECURITY DEFINER;

-- ============================================================================
-- RLS POLICIES (Drop existing policies first to avoid conflicts)
-- ============================================================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
DROP POLICY IF EXISTS "Admin can view all users" ON public.users;
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
DROP POLICY IF EXISTS "Owners can view own unit" ON public.units;
DROP POLICY IF EXISTS "Admin can manage units" ON public.units;
DROP POLICY IF EXISTS "Owners can view own record" ON public.owners;
DROP POLICY IF EXISTS "Admin can manage owners" ON public.owners;
DROP POLICY IF EXISTS "Owners can view own invoices" ON public.accounts_receivable;
DROP POLICY IF EXISTS "Admin can manage invoices" ON public.accounts_receivable;
DROP POLICY IF EXISTS "Users can view own service requests" ON public.service_requests;
DROP POLICY IF EXISTS "Users can create service requests" ON public.service_requests;
DROP POLICY IF EXISTS "Employees can update assigned requests" ON public.service_requests;
DROP POLICY IF EXISTS "Admin can manage service requests" ON public.service_requests;
DROP POLICY IF EXISTS "Users can view permitted documents" ON public.documents;
DROP POLICY IF EXISTS "Admin can manage documents" ON public.documents;
DROP POLICY IF EXISTS "Users can view own communications" ON public.communications;
DROP POLICY IF EXISTS "Users can send communications" ON public.communications;
DROP POLICY IF EXISTS "Owners can view own parking" ON public.parking_spaces;
DROP POLICY IF EXISTS "Admin can manage parking" ON public.parking_spaces;
DROP POLICY IF EXISTS "Owners can view own lockers" ON public.lockers;
DROP POLICY IF EXISTS "Admin can manage lockers" ON public.lockers;

-- Create policies
CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING (id = auth.uid());
CREATE POLICY "Admin can view all users" ON public.users FOR SELECT USING (is_admin_or_board());
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Owners can view own unit" ON public.units FOR SELECT USING (id = get_user_unit_id() OR is_admin_or_board());
CREATE POLICY "Admin can manage units" ON public.units FOR ALL USING (is_admin_or_board());

CREATE POLICY "Owners can view own record" ON public.owners FOR SELECT USING (user_id = auth.uid() OR is_admin_or_board());
CREATE POLICY "Admin can manage owners" ON public.owners FOR ALL USING (is_admin_or_board());

CREATE POLICY "Owners can view own invoices" ON public.accounts_receivable FOR SELECT USING (is_unit_owner(unit_id) OR is_admin_or_board());
CREATE POLICY "Admin can manage invoices" ON public.accounts_receivable FOR ALL USING (is_admin_or_board());

CREATE POLICY "Users can view own service requests" ON public.service_requests FOR SELECT USING (requester_id = auth.uid() OR is_unit_owner(unit_id) OR assigned_to = auth.uid() OR is_admin_or_board());
CREATE POLICY "Users can create service requests" ON public.service_requests FOR INSERT WITH CHECK (is_unit_owner(unit_id));
CREATE POLICY "Employees can update assigned requests" ON public.service_requests FOR UPDATE USING (assigned_to = auth.uid() OR is_admin_or_board());
CREATE POLICY "Admin can manage service requests" ON public.service_requests FOR ALL USING (is_admin_or_board());

CREATE POLICY "Users can view permitted documents" ON public.documents FOR SELECT USING (
  CASE visibility
    WHEN 'all_owners' THEN get_user_role() IN ('owner', 'board_member', 'administrator', 'super_admin')
    WHEN 'public_tenants' THEN auth.uid() IS NOT NULL
    WHEN 'board_only' THEN get_user_role() IN ('board_member', 'super_admin')
    WHEN 'admin_only' THEN get_user_role() IN ('administrator', 'super_admin')
    ELSE is_admin_or_board()
  END
);
CREATE POLICY "Admin can manage documents" ON public.documents FOR ALL USING (is_admin_or_board());

CREATE POLICY "Users can view own communications" ON public.communications FOR SELECT USING (from_user_id = auth.uid() OR auth.uid() = ANY(to_user_ids) OR is_admin_or_board());
CREATE POLICY "Users can send communications" ON public.communications FOR INSERT WITH CHECK (from_user_id = auth.uid());

CREATE POLICY "Owners can view own parking" ON public.parking_spaces FOR SELECT USING (is_unit_owner(unit_id) OR is_admin_or_board());
CREATE POLICY "Admin can manage parking" ON public.parking_spaces FOR ALL USING (is_admin_or_board());

CREATE POLICY "Owners can view own lockers" ON public.lockers FOR SELECT USING (is_unit_owner(unit_id) OR is_admin_or_board());
CREATE POLICY "Admin can manage lockers" ON public.lockers FOR ALL USING (is_admin_or_board());

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON public.users(role);
CREATE INDEX IF NOT EXISTS idx_units_number ON public.units(unit_number);
CREATE INDEX IF NOT EXISTS idx_owners_user_id ON public.owners(user_id);
CREATE INDEX IF NOT EXISTS idx_owners_unit_id ON public.owners(unit_id);
CREATE INDEX IF NOT EXISTS idx_accounts_receivable_unit_id ON public.accounts_receivable(unit_id);
CREATE INDEX IF NOT EXISTS idx_accounts_receivable_status ON public.accounts_receivable(status);
CREATE INDEX IF NOT EXISTS idx_service_requests_unit_id ON public.service_requests(unit_id);
CREATE INDEX IF NOT EXISTS idx_service_requests_status ON public.service_requests(status);
CREATE INDEX IF NOT EXISTS idx_service_requests_assigned_to ON public.service_requests(assigned_to);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_units_updated_at BEFORE UPDATE ON public.units FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_owners_updated_at BEFORE UPDATE ON public.owners FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_accounts_receivable_updated_at BEFORE UPDATE ON public.accounts_receivable FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
CREATE TRIGGER update_service_requests_updated_at BEFORE UPDATE ON public.service_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- ============================================================================
-- ⚠️ REPLACE 'YOUR_AUTH_USER_ID' WITH YOUR ACTUAL TEST USER UUID BELOW! ⚠️
-- ============================================================================

-- First, ensure the phone column exists (add it if missing)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema = 'public' 
    AND table_name = 'users' 
    AND column_name = 'phone'
  ) THEN
    ALTER TABLE public.users ADD COLUMN phone TEXT;
  END IF;
END $$;

-- Insert test user into public.users
INSERT INTO public.users (id, email, full_name, phone, role)
VALUES ('fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', 'test@lesdauphins.ca', 'Jean Tremblay', '514-555-0123', 'owner')
ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, full_name = EXCLUDED.full_name, phone = EXCLUDED.phone, role = EXCLUDED.role;

-- Create sample units
INSERT INTO public.units (id, unit_number, building_section, floor, ownership_percentage) VALUES
  ('11111111-1111-1111-1111-111111111111', '101', 'Tour Sud', 1, 0.0024),
  ('22222222-2222-2222-2222-222222222222', '102', 'Tour Sud', 1, 0.0024),
  ('33333333-3333-3333-3333-333333333333', '201', 'Tour Sud', 2, 0.0024),
  ('44444444-4444-4444-4444-444444444444', '301', 'Tour Nord', 3, 0.0024),
  ('55555555-5555-5555-5555-555555555555', '401', 'Tour Nord', 4, 0.0024),
  ('66666666-6666-6666-6666-666666666666', '501', 'Tour Nord', 5, 0.0024)
ON CONFLICT (id) DO NOTHING;

-- Create owner record
INSERT INTO public.owners (user_id, unit_id, primary_residence, mailing_address, emergency_contact, ownership_start_date, pre_authorized_payments)
VALUES (
  'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029',
  '33333333-3333-3333-3333-333333333333',
  true,
  '{"street": "3535 avenue Papineau, Apt 201", "city": "Montréal", "province": "QC", "postal_code": "H2K 4J9", "country": "Canada"}'::jsonb,
  '{"name": "Marie Tremblay", "phone": "514-555-0124", "email": "marie@example.com", "relationship": "Épouse"}'::jsonb,
  '2020-01-15',
  true
) ON CONFLICT (user_id, unit_id) DO NOTHING;

-- Create sample invoices
INSERT INTO public.accounts_receivable (unit_id, invoice_number, invoice_type, amount, due_date, status) VALUES
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-001', 'FAG', 425.00, '2025-02-01', 'pending'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-002', 'FAA', 85.00, '2025-02-01', 'pending'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-003', 'FDP', 125.00, '2025-02-01', 'pending'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-000', 'FAG', 425.00, '2025-01-01', 'paid'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2024-012', 'FAG', 425.00, '2024-12-01', 'overdue')
ON CONFLICT (invoice_number) DO NOTHING;

UPDATE public.accounts_receivable SET paid_date = '2025-01-05', payment_method = 'Prélèvement automatique' WHERE invoice_number = 'INV-2025-000';

-- Create sample service requests
INSERT INTO public.service_requests (request_number, unit_id, requester_id, request_type, priority, description, location_details, status) VALUES
  ('SR-2025-001', '33333333-3333-3333-3333-333333333333', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', 'Plomberie', 'high', 'Fuite d''eau sous l''évier de la cuisine.', 'Cuisine, sous l''évier', 'assigned'),
  ('SR-2025-002', '33333333-3333-3333-3333-333333333333', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', 'Électricité', 'low', 'Une prise électrique dans la chambre ne fonctionne plus.', 'Chambre principale, mur nord', 'submitted'),
  ('SR-2024-150', '33333333-3333-3333-3333-333333333333', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', 'Chauffage', 'medium', 'Le thermostat ne répond pas correctement.', 'Salon', 'completed')
ON CONFLICT (request_number) DO NOTHING;

UPDATE public.service_requests SET completed_date = '2024-12-15', resolution_notes = 'Thermostat remplacé.', cost = 85.00, fund_charged = 'owner_responsibility' WHERE request_number = 'SR-2024-150';

-- Create parking spaces
INSERT INTO public.parking_spaces (unit_id, space_number, type, vehicle_plate, vehicle_make_model) VALUES
  ('33333333-3333-3333-3333-333333333333', 'P-201', 'interior', 'ABC 123', 'Toyota Camry 2020'),
  ('11111111-1111-1111-1111-111111111111', 'P-101', 'interior', NULL, NULL)
ON CONFLICT (space_number) DO NOTHING;

-- Create lockers
INSERT INTO public.lockers (unit_id, locker_number, location) VALUES
  ('33333333-3333-3333-3333-333333333333', 'L-201', 'Sous-sol, section A'),
  ('11111111-1111-1111-1111-111111111111', 'L-101', 'Sous-sol, section A')
ON CONFLICT (locker_number) DO NOTHING;

-- Create documents
INSERT INTO public.documents (category, title, file_url, file_type, file_size, visibility, uploaded_by) VALUES
  ('Financier', 'États financiers 2024', '/documents/financier/etats-2024.pdf', 'application/pdf', 2048576, 'all_owners', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029'),
  ('Gouvernance', 'AGA 2024 - Procès-verbal', '/documents/gouvernance/pv-aga-2024.pdf', 'application/pdf', 1024000, 'all_owners', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029')
ON CONFLICT DO NOTHING;

-- Create communications
INSERT INTO public.communications (communication_type, from_user_id, to_user_ids, subject, body) VALUES
  ('announcement', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', ARRAY['fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029']::UUID[], 'Assemblée générale annuelle - 15 mars 2025', 'Chers copropriétaires, vous êtes invités à l''AGA le 15 mars 2025 à 19h00.'),
  ('announcement', 'fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029', ARRAY['fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029']::UUID[], 'Travaux d''entretien préventif - 10 mars 2025', 'Inspection des ascenseurs le 10 mars entre 9h00 et 17h00.')
ON CONFLICT DO NOTHING;

-- Done!
DO $$
BEGIN
  RAISE NOTICE '✅ Setup complete! Tables created and sample data inserted.';
  RAISE NOTICE '✅ User ID configured: fdc1d3ce-495b-4bc0-8cfa-b1e997f9a029';
  RAISE NOTICE '📧 Login: test@lesdauphins.ca';
  RAISE NOTICE '🏠 Unit: 201 (Tour Sud)';
  RAISE NOTICE '💰 Invoices: 5 created (3 pending, 1 paid, 1 overdue)';
  RAISE NOTICE '🔧 Service Requests: 3 created';
  RAISE NOTICE '';
  RAISE NOTICE '🚀 Ready to launch! Run: npm run dev';
END $$;

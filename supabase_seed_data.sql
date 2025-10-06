-- ============================================================================
-- SEED DATA - Les Dauphins Portal
-- Run this AFTER creating a test user in Supabase Authentication
-- ============================================================================

-- IMPORTANT: Replace 'YOUR_AUTH_USER_ID' with the actual UUID from auth.users
-- You can find this in Supabase Dashboard > Authentication > Users > Copy User ID

-- ============================================================================
-- 1. INSERT TEST USER INTO PUBLIC.USERS
-- ============================================================================
-- Replace the UUID below with your test user's auth.uid()

INSERT INTO public.users (id, email, full_name, phone, role)
VALUES 
  ('YOUR_AUTH_USER_ID', 'test@lesdauphins.ca', 'Jean Tremblay', '514-555-0123', 'owner')
ON CONFLICT (id) DO UPDATE
  SET email = EXCLUDED.email,
      full_name = EXCLUDED.full_name,
      phone = EXCLUDED.phone,
      role = EXCLUDED.role;

-- ============================================================================
-- 2. CREATE SAMPLE UNITS
-- ============================================================================

INSERT INTO public.units (id, unit_number, building_section, floor, ownership_percentage)
VALUES 
  ('11111111-1111-1111-1111-111111111111', '101', 'Tour Sud', 1, 0.0024),
  ('22222222-2222-2222-2222-222222222222', '102', 'Tour Sud', 1, 0.0024),
  ('33333333-3333-3333-3333-333333333333', '201', 'Tour Sud', 2, 0.0024),
  ('44444444-4444-4444-4444-444444444444', '301', 'Tour Nord', 3, 0.0024),
  ('55555555-5555-5555-5555-555555555555', '401', 'Tour Nord', 4, 0.0024),
  ('66666666-6666-6666-6666-666666666666', '501', 'Tour Nord', 5, 0.0024)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- 3. CREATE OWNER RECORD FOR TEST USER
-- ============================================================================
-- This links the test user to unit 201

INSERT INTO public.owners (user_id, unit_id, primary_residence, mailing_address, emergency_contact, ownership_start_date, pre_authorized_payments)
VALUES (
  'YOUR_AUTH_USER_ID',
  '33333333-3333-3333-3333-333333333333', -- Unit 201
  true,
  '{"street": "3535 avenue Papineau, Apt 201", "city": "Montréal", "province": "QC", "postal_code": "H2K 4J9", "country": "Canada"}'::jsonb,
  '{"name": "Marie Tremblay", "phone": "514-555-0124", "email": "marie@example.com", "relationship": "Épouse"}'::jsonb,
  '2020-01-15',
  true
)
ON CONFLICT (user_id, unit_id) DO NOTHING;

-- ============================================================================
-- 4. CREATE SAMPLE INVOICES
-- ============================================================================

INSERT INTO public.accounts_receivable (unit_id, invoice_number, invoice_type, amount, due_date, status)
VALUES 
  -- Pending invoices for test user's unit
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-001', 'FAG', 425.00, '2025-02-01', 'pending'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-002', 'FAA', 85.00, '2025-02-01', 'pending'),
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-003', 'FDP', 125.00, '2025-02-01', 'pending'),
  
  -- Paid invoice from last month
  ('33333333-3333-3333-3333-333333333333', 'INV-2025-000', 'FAG', 425.00, '2025-01-01', 'paid'),
  
  -- Overdue invoice
  ('33333333-3333-3333-3333-333333333333', 'INV-2024-012', 'FAG', 425.00, '2024-12-01', 'overdue')
ON CONFLICT (invoice_number) DO NOTHING;

-- Update the paid invoice with payment info
UPDATE public.accounts_receivable
SET paid_date = '2025-01-05', payment_method = 'Prélèvement automatique'
WHERE invoice_number = 'INV-2025-000';

-- ============================================================================
-- 5. CREATE SAMPLE SERVICE REQUESTS
-- ============================================================================

INSERT INTO public.service_requests (
  request_number, unit_id, requester_id, request_type, priority, 
  description, location_details, status
)
VALUES 
  (
    'SR-2025-001',
    '33333333-3333-3333-3333-333333333333',
    'YOUR_AUTH_USER_ID',
    'Plomberie',
    'high',
    'Fuite d''eau sous l''évier de la cuisine. L''eau coule lentement mais constamment.',
    'Cuisine, sous l''évier',
    'assigned'
  ),
  (
    'SR-2025-002',
    '33333333-3333-3333-3333-333333333333',
    'YOUR_AUTH_USER_ID',
    'Électricité',
    'low',
    'Une prise électrique dans la chambre ne fonctionne plus.',
    'Chambre principale, mur nord',
    'submitted'
  ),
  (
    'SR-2024-150',
    '33333333-3333-3333-3333-333333333333',
    'YOUR_AUTH_USER_ID',
    'Chauffage',
    'medium',
    'Le thermostat ne répond pas correctement. La température varie beaucoup.',
    'Salon',
    'completed'
  )
ON CONFLICT (request_number) DO NOTHING;

-- Update completed request
UPDATE public.service_requests
SET completed_date = '2024-12-15',
    resolution_notes = 'Thermostat remplacé. Fonctionne normalement.',
    cost = 85.00,
    fund_charged = 'owner_responsibility'
WHERE request_number = 'SR-2024-150';

-- ============================================================================
-- 6. CREATE SAMPLE PARKING SPACES
-- ============================================================================

INSERT INTO public.parking_spaces (unit_id, space_number, type, vehicle_plate, vehicle_make_model)
VALUES 
  ('33333333-3333-3333-3333-333333333333', 'P-201', 'interior', 'ABC 123', 'Toyota Camry 2020'),
  ('11111111-1111-1111-1111-111111111111', 'P-101', 'interior', NULL, NULL),
  ('22222222-2222-2222-2222-222222222222', 'P-102', 'exterior', 'XYZ 789', 'Honda Civic 2019')
ON CONFLICT (space_number) DO NOTHING;

-- ============================================================================
-- 7. CREATE SAMPLE LOCKERS
-- ============================================================================

INSERT INTO public.lockers (unit_id, locker_number, location)
VALUES 
  ('33333333-3333-3333-3333-333333333333', 'L-201', 'Sous-sol, section A'),
  ('11111111-1111-1111-1111-111111111111', 'L-101', 'Sous-sol, section A'),
  ('44444444-4444-4444-4444-444444444444', 'L-301', 'Sous-sol, section B')
ON CONFLICT (locker_number) DO NOTHING;

-- ============================================================================
-- 8. CREATE SAMPLE DOCUMENTS
-- ============================================================================

INSERT INTO public.documents (
  category, subcategory, title, description, file_url, file_type, 
  file_size, fiscal_year, visibility, uploaded_by
)
VALUES 
  (
    'Financier',
    'États financiers',
    'États financiers 2024',
    'États financiers annuels pour l''exercice 2024',
    '/documents/financier/etats-financiers-2024.pdf',
    'application/pdf',
    2048576,
    2024,
    'all_owners',
    'YOUR_AUTH_USER_ID'
  ),
  (
    'Gouvernance',
    'Procès-verbaux',
    'AGA 2024 - Procès-verbal',
    'Procès-verbal de l''assemblée générale annuelle 2024',
    '/documents/gouvernance/pv-aga-2024.pdf',
    'application/pdf',
    1024000,
    2024,
    'all_owners',
    'YOUR_AUTH_USER_ID'
  ),
  (
    'Règlements',
    'Règlements internes',
    'Règlement de régie interne',
    'Règlement de régie interne mis à jour en 2024',
    '/documents/reglements/regie-interne-2024.pdf',
    'application/pdf',
    512000,
    2024,
    'public_tenants',
    'YOUR_AUTH_USER_ID'
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- 9. CREATE SAMPLE COMMUNICATIONS
-- ============================================================================

INSERT INTO public.communications (
  communication_type, from_user_id, to_user_ids, subject, body
)
VALUES 
  (
    'announcement',
    'YOUR_AUTH_USER_ID',
    ARRAY['YOUR_AUTH_USER_ID']::UUID[],
    'Assemblée générale annuelle - 15 mars 2025',
    'Chers copropriétaires,

Vous êtes cordialement invités à participer à l''assemblée générale annuelle qui se tiendra le 15 mars 2025 à 19h00.

Ordre du jour :
1. Présentation des états financiers 2024
2. Budget prévisionnel 2025
3. Projets de rénovation
4. Période de questions

La participation peut se faire en personne ou virtuellement via Zoom.

Cordialement,
Le Conseil d''Administration'
  ),
  (
    'announcement',
    'YOUR_AUTH_USER_ID',
    ARRAY['YOUR_AUTH_USER_ID']::UUID[],
    'Travaux d''entretien préventif - 10 mars 2025',
    'Chers résidents,

Les travaux d''inspection annuelle des ascenseurs auront lieu le 10 mars 2025 entre 9h00 et 17h00.

Durant cette période, les ascenseurs seront hors service par intermittence. Nous vous recommandons de prévoir vos déplacements en conséquence.

Merci de votre compréhension,
L''Administration'
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Sample data inserted successfully!';
  RAISE NOTICE '';
  RAISE NOTICE '📊 Summary:';
  RAISE NOTICE '   - 6 units created';
  RAISE NOTICE '   - 1 owner account (Jean Tremblay, Unit 201)';
  RAISE NOTICE '   - 5 invoices (3 pending, 1 paid, 1 overdue)';
  RAISE NOTICE '   - 3 service requests';
  RAISE NOTICE '   - 3 parking spaces';
  RAISE NOTICE '   - 3 lockers';
  RAISE NOTICE '   - 3 documents';
  RAISE NOTICE '   - 2 announcements';
  RAISE NOTICE '';
  RAISE NOTICE '⚠️  IMPORTANT: Remember to replace YOUR_AUTH_USER_ID with actual user ID!';
END $$;

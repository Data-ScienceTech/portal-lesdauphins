import { Link, Routes, Route } from 'react-router-dom'
import { useAuth } from '@/contexts/AuthContext'
import { useLanguage } from '@/contexts/LanguageContext'
import { Home, FileText, Wrench, Settings, LogOut, Globe } from 'lucide-react'

function DashboardHome() {
  const { user } = useAuth()
  const { t } = useLanguage()
  
  return (
    <div className="space-y-6">
      <div className="glass-card-ocean rounded-2xl p-8 shadow-lg">
        <h2 className="text-3xl font-bold text-ocean mb-2">
          {t('dashboard.welcome')}
        </h2>
        <p className="text-gray-600">
          {t('dashboard.hello')} {user?.email} 👋
        </p>
      </div>

      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="glass-card rounded-xl p-6 hover-lift cursor-pointer border-l-4 border-cyan-500">
          <div className="flex items-center justify-between mb-4">
            <FileText className="w-8 h-8 text-cyan-600" />
            <span className="text-2xl font-bold text-cyan-600">3</span>
          </div>
          <h3 className="font-semibold text-gray-800 mb-1">{t('dashboard.pendingInvoices')}</h3>
          <p className="text-sm text-gray-600">{t('dashboard.total')}: 1,250.00 $</p>
        </div>

        <div className="glass-card rounded-xl p-6 hover-lift cursor-pointer border-l-4 border-teal-500">
          <div className="flex items-center justify-between mb-4">
            <Wrench className="w-8 h-8 text-teal-600" />
            <span className="text-2xl font-bold text-teal-600">1</span>
          </div>
          <h3 className="font-semibold text-gray-800 mb-1">{t('dashboard.activeRequests')}</h3>
          <p className="text-sm text-gray-600">1 {t('dashboard.assigned')}</p>
        </div>

        <div className="glass-card rounded-xl p-6 hover-lift cursor-pointer border-l-4 border-blue-500">
          <div className="flex items-center justify-between mb-4">
            <FileText className="w-8 h-8 text-blue-600" />
            <span className="text-2xl font-bold text-blue-600">12</span>
          </div>
          <h3 className="font-semibold text-gray-800 mb-1">{t('dashboard.documents')}</h3>
          <p className="text-sm text-gray-600">{t('dashboard.newThisMonth')}</p>
        </div>
      </div>

      <div className="glass-card-ocean rounded-2xl p-8 shadow-lg">
        <h3 className="text-xl font-bold text-gray-800 mb-4">{t('dashboard.communications')}</h3>
        <div className="space-y-3">
          <div className="border-l-4 border-cyan-500 pl-4 py-2 bg-cyan-50/50 rounded-r">
            <p className="font-medium text-gray-800">Assemblée générale annuelle - 15 mars 2025</p>
            <p className="text-sm text-gray-600">Convocation envoyée - Confirmez votre présence</p>
          </div>
          <div className="border-l-4 border-gray-300 pl-4 py-2">
            <p className="font-medium text-gray-800">Travaux d'entretien préventif</p>
            <p className="text-sm text-gray-600">Inspection des ascenseurs - 10 mars 2025</p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default function MemberDashboard() {
  const { signOut, user } = useAuth()
  const { language, setLanguage, t } = useLanguage()

  const handleSignOut = async () => {
    await signOut()
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-cyan-50 via-blue-50 to-slate-50">
      {/* Navigation */}
      <nav className="nav-sticky dolphin-wave shadow-md">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-3">
              <svg className="w-8 h-8 text-cyan-600" fill="currentColor" viewBox="0 0 24 24">
                <path d="M19.5 12c0-1.77-.96-3.31-2.39-4.16C17.77 6.58 18 5.08 18 4.5c0-1.88-.91-2.5-2-2.5-1.45 0-2.78.76-3.92 1.64C11.35 3.23 10.68 3 10 3c-3.87 0-7 3.13-7 7 0 2.21 1.03 4.18 2.63 5.45C5.23 16.25 5 17.1 5 18c0 2.21 1.79 4 4 4 .74 0 1.43-.21 2.03-.56C12.16 22.42 13.54 23 15 23c2.21 0 4-1.79 4-4 0-.89-.3-1.72-.78-2.38 1.18-.82 1.78-2.14 1.78-3.62zm-9.5 8c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
              </svg>
              <span className="text-2xl font-bold bg-gradient-to-r from-cyan-700 via-blue-700 to-cyan-600 bg-clip-text text-transparent">Les Dauphins</span>
              <span className="text-sm text-gray-500 ml-2">{t('dashboard.portal')}</span>
            </div>
            <div className="flex items-center space-x-4">
              <button onClick={() => setLanguage(language === 'fr' ? 'en' : 'fr')} className="p-2 rounded-full hover:bg-cyan-50 transition">
                <Globe className="w-5 h-5 text-gray-600" />
              </button>
              <span className="text-sm text-gray-600">{user?.email}</span>
              <button onClick={handleSignOut} className="flex items-center space-x-2 text-gray-600 hover:text-red-600 transition">
                <LogOut className="w-5 h-5" />
                <span className="text-sm">{t('nav.logout')}</span>
              </button>
            </div>
          </div>
        </div>
      </nav>

      <div className="container mx-auto px-6 py-8">
        <div className="flex gap-6">
          {/* Sidebar */}
          <aside className="w-64 shrink-0">
            <div className="glass-card rounded-xl p-4 space-y-2 shadow-lg">
              <Link to="/portail" className="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-cyan-50 hover:text-cyan-700 transition">
                <Home className="w-5 h-5" />
                <span>{t('sidebar.dashboard')}</span>
              </Link>
              <Link to="/portail/factures" className="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-cyan-50 hover:text-cyan-700 transition">
                <FileText className="w-5 h-5" />
                <span>{t('sidebar.invoices')}</span>
              </Link>
              <Link to="/portail/demandes" className="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-cyan-50 hover:text-cyan-700 transition">
                <Wrench className="w-5 h-5" />
                <span>{t('sidebar.requests')}</span>
              </Link>
              <Link to="/portail/profil" className="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-cyan-50 hover:text-cyan-700 transition">
                <Settings className="w-5 h-5" />
                <span>{t('sidebar.profile')}</span>
              </Link>
            </div>
          </aside>

          {/* Main Content */}
          <main className="flex-1">
            <Routes>
              <Route path="/" element={<DashboardHome />} />
              <Route path="/factures" element={<div className="glass-card rounded-2xl p-8"><h2 className="text-2xl font-bold">Factures</h2><p className="text-gray-600 mt-2">Section en développement...</p></div>} />
              <Route path="/demandes" element={<div className="glass-card rounded-2xl p-8"><h2 className="text-2xl font-bold">Demandes de service</h2><p className="text-gray-600 mt-2">Section en développement...</p></div>} />
              <Route path="/profil" element={<div className="glass-card rounded-2xl p-8"><h2 className="text-2xl font-bold">Mon profil</h2><p className="text-gray-600 mt-2">Section en développement...</p></div>} />
            </Routes>
          </main>
        </div>
      </div>
    </div>
  )
}

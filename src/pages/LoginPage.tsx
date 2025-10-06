import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '@/contexts/AuthContext'
import { useLanguage } from '@/contexts/LanguageContext'
import { Globe } from 'lucide-react'

export default function LoginPage() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const { signIn } = useAuth()
  const { language, setLanguage, t } = useLanguage()
  const navigate = useNavigate()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')
    setLoading(true)

    try {
      const { error } = await signIn(email, password)
      if (error) {
        setError(error.message)
      } else {
        navigate('/portail')
      }
    } catch (err) {
      setError('Une erreur est survenue. Veuillez réessayer.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen hero-gradient flex items-center justify-center px-4">
      <div className="max-w-md w-full">
        {/* Header */}
        <div className="text-center mb-8">
          <Link to="/" className="inline-flex items-center space-x-2 mb-6">
            <svg className="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
              <path d="M19.5 12c0-1.77-.96-3.31-2.39-4.16C17.77 6.58 18 5.08 18 4.5c0-1.88-.91-2.5-2-2.5-1.45 0-2.78.76-3.92 1.64C11.35 3.23 10.68 3 10 3c-3.87 0-7 3.13-7 7 0 2.21 1.03 4.18 2.63 5.45C5.23 16.25 5 17.1 5 18c0 2.21 1.79 4 4 4 .74 0 1.43-.21 2.03-.56C12.16 22.42 13.54 23 15 23c2.21 0 4-1.79 4-4 0-.89-.3-1.72-.78-2.38 1.18-.82 1.78-2.14 1.78-3.62zm-9.5 8c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z"/>
            </svg>
            <span className="text-3xl font-bold text-white">Les Dauphins</span>
          </Link>
          <div className="flex items-center justify-center gap-4 mb-4">
            <h1 className="text-3xl font-bold text-white">{t('login.title')}</h1>
            <button onClick={() => setLanguage(language === 'fr' ? 'en' : 'fr')} className="p-2 rounded-full bg-white/20 hover:bg-white/30 transition">
              <Globe className="w-5 h-5 text-white" />
            </button>
          </div>
          <p className="text-cyan-100">{t('login.subtitle')}</p>
        </div>

        {/* Login Form */}
        <div className="glass-card rounded-2xl p-8 shadow-2xl">
          <form onSubmit={handleSubmit} className="space-y-6">
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                {t('login.email')}
              </label>
              <input
                id="email"
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                placeholder="votre@email.com"
              />
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-2">
                {t('login.password')}
              </label>
              <input
                id="password"
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                placeholder="••••••••"
              />
            </div>

            <div className="flex items-center justify-between">
              <label className="flex items-center">
                <input type="checkbox" className="rounded border-gray-300 text-cyan-600 focus:ring-cyan-500" />
                <span className="ml-2 text-sm text-gray-600">{t('login.remember')}</span>
              </label>
              <a href="#" className="text-sm text-cyan-600 hover:text-cyan-700">
                {t('login.forgot')}
              </a>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full btn-ocean py-3 rounded-lg font-semibold focus:ring-4 focus:ring-cyan-500 focus:ring-opacity-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? t('login.loading') : t('login.submit')}
            </button>
          </form>

          <div className="mt-6 pt-6 border-t border-gray-200 text-center">
            <p className="text-sm text-gray-600">
              {t('login.newUser')}{' '}
              <a href="#" className="text-cyan-600 hover:text-cyan-700 font-medium">
                {t('login.createAccount')}
              </a>
            </p>
          </div>
        </div>

        {/* Back to Home */}
        <div className="text-center mt-8">
          <Link 
            to="/" 
            className="inline-flex items-center justify-center gap-2 px-6 py-3 bg-white/10 hover:bg-white/20 text-white rounded-lg text-sm font-medium transition-all duration-200 hover:scale-105 border border-white/20 hover:border-white/40"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            {t('login.backToSite')}
          </Link>
        </div>
      </div>
    </div>
  )
}

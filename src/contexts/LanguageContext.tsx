import { createContext, useContext, useState, ReactNode } from 'react'

type Language = 'fr' | 'en'

interface LanguageContextType {
  language: Language
  setLanguage: (lang: Language) => void
  t: (key: string) => string
}

const translations = {
  fr: {
    // Navigation
    'nav.home': 'Accueil',
    'nav.history': 'Histoire',
    'nav.plateau': 'Le Plateau',
    'nav.condo': 'Notre Copropriété',
    'nav.contact': 'Contact',
    'nav.login': 'Connexion',
    'nav.logout': 'Déconnexion',
    
    // Hero
    'hero.title': 'Les Dauphins',
    'hero.subtitle': 'Une communauté vibrante au cœur du Plateau Mont-Royal',
    'hero.cta1': 'Découvrir notre histoire',
    'hero.cta2': 'Nous contacter',
    
    // History
    'history.title': 'Notre Histoire',
    'history.p1': 'Construit au début des années 1980, Les Dauphins représente l\'une des premières grandes copropriétés modernes du Plateau Mont-Royal. Notre bâtiment iconique, avec ses Tours Sud et Nord reliées par un ascenseur central, est devenu au fil des décennies un symbole de vie communautaire et de qualité architecturale.',
    'history.p2': 'Le nom "Les Dauphins" évoque l\'élégance et l\'intelligence de ces mammifères marins, reflétant notre engagement envers une communauté harmonieuse où chaque résident contribue au bien-être collectif.',
    'history.p3': 'Depuis plus de 40 ans, notre copropriété a su maintenir ses standards d\'excellence tout en s\'adaptant aux besoins modernes de ses résidents.',
    
    // Plateau
    'plateau.title': 'Le Plateau Mont-Royal',
    'plateau.mythic.title': 'Un quartier mythique',
    'plateau.mythic.text': 'Le Plateau Mont-Royal est reconnu comme l\'un des quartiers les plus dynamiques et culturellement riches de Montréal. Avec ses rues bordées d\'arbres centenaires, ses escaliers extérieurs colorés et son architecture distinctive, le Plateau incarne l\'essence même de Montréal.',
    'plateau.culture.title': 'Vie culturelle',
    'plateau.culture.text': 'Notre quartier regorge de cafés artisanaux, de restaurants primés, de boutiques indépendantes et de galeries d\'art. Le célèbre parc La Fontaine, les cinémas et la rue Saint-Denis animée sont à quelques minutes de marche.',
    'plateau.access.title': 'Accessibilité',
    'plateau.access.text': 'Parfaitement desservi par les transports en commun avec plusieurs stations de métro à proximité (Mont-Royal, Laurier, Sherbrooke), le Plateau offre un accès facile au centre-ville.',
    'plateau.diversity.title': 'Diversité',
    'plateau.diversity.text': 'Le Plateau est reconnu pour sa diversité culturelle et sa population cosmopolite. Des étudiants aux jeunes familles, des artistes aux professionnels, le quartier attire une communauté ouverte d\'esprit.',
    
    // Contact
    'contact.title': 'Contactez-nous',
    'contact.subtitle': 'Pour toute question concernant notre copropriété, n\'hésitez pas à nous contacter.',
    'contact.admin': 'Administration',
    'contact.email': 'Courriel',
    'contact.phone': 'Téléphone',
    'contact.hours': 'Heures d\'ouverture',
    'contact.weekdays': 'Lundi - Vendredi',
    'contact.emergency': 'Urgences',
    'contact.portal': 'Accéder au portail des copropriétaires',
    
    // Login
    'login.title': 'Portail des Copropriétaires',
    'login.subtitle': 'Connectez-vous pour accéder à votre espace personnel',
    'login.email': 'Adresse courriel',
    'login.password': 'Mot de passe',
    'login.remember': 'Se souvenir de moi',
    'login.forgot': 'Mot de passe oublié?',
    'login.submit': 'Se connecter',
    'login.loading': 'Connexion...',
    'login.newUser': 'Nouveau copropriétaire?',
    'login.createAccount': 'Créer un compte',
    'login.backToSite': 'Retour au site',
    
    // Dashboard
    'dashboard.welcome': 'Bienvenue sur votre portail',
    'dashboard.hello': 'Bonjour',
    'dashboard.pendingInvoices': 'Factures en attente',
    'dashboard.total': 'Total',
    'dashboard.activeRequests': 'Demandes en cours',
    'dashboard.assigned': 'assignée',
    'dashboard.documents': 'Documents',
    'dashboard.newThisMonth': 'Nouveaux ce mois-ci',
    'dashboard.communications': 'Dernières communications',
    'dashboard.portal': 'Portail Copropriétaires',
    
    // Sidebar
    'sidebar.dashboard': 'Tableau de bord',
    'sidebar.invoices': 'Factures',
    'sidebar.requests': 'Demandes de service',
    'sidebar.documents': 'Documents',
    'sidebar.profile': 'Mon profil',
    
    // Footer
    'footer.description': 'Copropriété de prestige sur le Plateau Mont-Royal depuis plus de 40 ans.',
    'footer.quickLinks': 'Liens rapides',
    'footer.address': 'Adresse',
    'footer.rights': 'Tous droits réservés',
    'footer.location': 'Copropriété sur le Plateau Mont-Royal, Montréal, Québec',
  },
  en: {
    // Navigation
    'nav.home': 'Home',
    'nav.history': 'History',
    'nav.plateau': 'The Plateau',
    'nav.condo': 'Our Condominium',
    'nav.contact': 'Contact',
    'nav.login': 'Login',
    'nav.logout': 'Logout',
    
    // Hero
    'hero.title': 'Les Dauphins',
    'hero.subtitle': 'A vibrant community in the heart of the Plateau Mont-Royal',
    'hero.cta1': 'Discover our history',
    'hero.cta2': 'Contact us',
    
    // History
    'history.title': 'Our History',
    'history.p1': 'Built in the early 1980s, Les Dauphins represents one of the first major modern condominiums in the Plateau Mont-Royal. Our iconic building, with its South and North Towers connected by a central elevator, has become over the decades a symbol of community living and architectural quality.',
    'history.p2': 'The name "Les Dauphins" evokes the elegance and intelligence of these marine mammals, reflecting our commitment to a harmonious community where each resident contributes to collective well-being.',
    'history.p3': 'For over 40 years, our condominium has maintained its standards of excellence while adapting to the modern needs of its residents.',
    
    // Plateau
    'plateau.title': 'The Plateau Mont-Royal',
    'plateau.mythic.title': 'A legendary neighborhood',
    'plateau.mythic.text': 'The Plateau Mont-Royal is recognized as one of Montreal\'s most dynamic and culturally rich neighborhoods. With its tree-lined streets, colorful exterior staircases and distinctive architecture, the Plateau embodies the very essence of Montreal.',
    'plateau.culture.title': 'Cultural life',
    'plateau.culture.text': 'Our neighborhood is full of artisanal cafés, award-winning restaurants, independent boutiques and art galleries. The famous Parc La Fontaine, cinemas and the lively Saint-Denis Street are just minutes away.',
    'plateau.access.title': 'Accessibility',
    'plateau.access.text': 'Perfectly served by public transit with several metro stations nearby (Mont-Royal, Laurier, Sherbrooke), the Plateau offers easy access to downtown.',
    'plateau.diversity.title': 'Diversity',
    'plateau.diversity.text': 'The Plateau is recognized for its cultural diversity and cosmopolitan population. From students to young families, artists to professionals, the neighborhood attracts an open-minded community.',
    
    // Contact
    'contact.title': 'Contact Us',
    'contact.subtitle': 'For any questions about our condominium, please don\'t hesitate to contact us.',
    'contact.admin': 'Administration',
    'contact.email': 'Email',
    'contact.phone': 'Phone',
    'contact.hours': 'Office Hours',
    'contact.weekdays': 'Monday - Friday',
    'contact.emergency': 'Emergencies',
    'contact.portal': 'Access the owners portal',
    
    // Login
    'login.title': 'Owners Portal',
    'login.subtitle': 'Sign in to access your personal space',
    'login.email': 'Email address',
    'login.password': 'Password',
    'login.remember': 'Remember me',
    'login.forgot': 'Forgot password?',
    'login.submit': 'Sign in',
    'login.loading': 'Signing in...',
    'login.newUser': 'New owner?',
    'login.createAccount': 'Create an account',
    'login.backToSite': 'Back to website',
    
    // Dashboard
    'dashboard.welcome': 'Welcome to your portal',
    'dashboard.hello': 'Hello',
    'dashboard.pendingInvoices': 'Pending invoices',
    'dashboard.total': 'Total',
    'dashboard.activeRequests': 'Active requests',
    'dashboard.assigned': 'assigned',
    'dashboard.documents': 'Documents',
    'dashboard.newThisMonth': 'New this month',
    'dashboard.communications': 'Latest communications',
    'dashboard.portal': 'Owners Portal',
    
    // Sidebar
    'sidebar.dashboard': 'Dashboard',
    'sidebar.invoices': 'Invoices',
    'sidebar.requests': 'Service requests',
    'sidebar.documents': 'Documents',
    'sidebar.profile': 'My profile',
    
    // Footer
    'footer.description': 'Prestigious condominium on the Plateau Mont-Royal for over 40 years.',
    'footer.quickLinks': 'Quick links',
    'footer.address': 'Address',
    'footer.rights': 'All rights reserved',
    'footer.location': 'Condominium on the Plateau Mont-Royal, Montreal, Quebec',
  }
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export const LanguageProvider = ({ children }: { children: ReactNode }) => {
  const [language, setLanguage] = useState<Language>('fr')

  const t = (key: string): string => {
    return translations[language][key as keyof typeof translations.fr] || key
  }

  return (
    <LanguageContext.Provider value={{ language, setLanguage, t }}>
      {children}
    </LanguageContext.Provider>
  )
}

export const useLanguage = () => {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider')
  }
  return context
}

const supabase = require('../config/supabase');
const bcrypt = require('bcryptjs');

// Usuarios demo cuando Supabase no está configurado
const DEMO_USERS = [
  {
    id: 1,
    name: 'Administrador',
    email: 'admin@potenciaactiva.com',
    password: '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // admin123
    role: 'admin'
  },
  {
    id: 2,
    name: 'Usuario Prueba',
    email: 'usuario@potenciaactiva.com', 
    password: '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // user123
    role: 'user'
  },
  {
    id: 3,
    name: 'Demo User',
    email: 'demo@demo.com',
    password: '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // demo123
    role: 'user'
  }
];

class AuthController {
  // Renderizar página de login
  static async renderLogin(req, res) {
    if (req.session.user) {
      return res.redirect('/dashboard');
    }
    res.render('layouts/main', { 
      title: 'POTENCIA ACTIVA - Login', 
      page: '../pages/login' 
    });
  }

  // Renderizar dashboard (requiere autenticación)
  static async renderDashboard(req, res) {
    if (!req.session.user) {
      console.log('❌ No session user found');
      return res.redirect('/login');
    }
    
    console.log('✅ Session user found:', req.session.user);
    
    res.render('layouts/dashboard', {
      title: 'Dashboard - POTENCIA ACTIVA',
      page: '../pages/dashboard-new',
      user: req.session.user
    });
  }

  // Procesar login
  static async login(req, res) {
    try {
      const { email, password } = req.body;

      console.log('🔍 Login attempt:', { email, password: password ? '[HIDDEN]' : 'EMPTY' });

      if (!email || !password) {
        return res.status(400).json({ 
          success: false, 
          message: 'Email y contraseña son requeridos' 
        });
      }

      let user = null;

      if (supabase) {
        console.log('✅ Using Supabase for authentication');
        // Usar Supabase si está configurado
        const { data: supabaseUser, error } = await supabase
          .from('users')
          .select('*')
          .eq('email', email)
          .single();

        console.log('🔍 Supabase query result:', { 
          user: supabaseUser ? 'FOUND' : 'NOT_FOUND', 
          error: error?.message 
        });

        if (!error && supabaseUser) {
          user = supabaseUser;
        }
      } else {
        console.log('⚠️  Using demo users for authentication');
        // Usar usuarios demo si Supabase no está configurado
        user = DEMO_USERS.find(u => u.email === email);
      }

      if (!user) {
        console.log('❌ User not found for email:', email);
        return res.status(401).json({ 
          success: false, 
          message: 'Credenciales incorrectas' 
        });
      }

      console.log('👤 User found:', { 
        id: user.id, 
        email: user.email, 
        hasPassword: user.password ? 'YES' : 'NO' 
      });

      // Verificar contraseña
      const isValidPassword = await bcrypt.compare(password, user.password);
      
      console.log('🔐 Password validation:', { 
        isValid: isValidPassword,
        providedPassword: '[HIDDEN]',
        storedHash: user.password ? user.password.substring(0, 10) + '...' : 'NONE'
      });
      
      if (!isValidPassword) {
        console.log('❌ Invalid password for user:', email);
        return res.status(401).json({ 
          success: false, 
          message: 'Credenciales incorrectas' 
        });
      }

      // Guardar usuario en sesión
      req.session.user = {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role
      };

      // Guardar sesión explícitamente antes de enviar respuesta
      req.session.save((err) => {
        if (err) {
          console.error('Error al guardar sesión:', err);
          return res.status(500).json({ 
            success: false, 
            message: 'Error al guardar sesión' 
          });
        }

        console.log('✅ Sesión guardada correctamente');
        res.json({ 
          success: true, 
          message: 'Login exitoso',
          redirectUrl: '/dashboard'
        });
      });

    } catch (error) {
      console.error('Error en login:', error);
      res.status(500).json({ 
        success: false, 
        message: 'Error interno del servidor' 
      });
    }
  }

  // Procesar registro
  static async register(req, res) {
    try {
      if (!supabase) {
        return res.status(503).json({ 
          success: false, 
          message: 'Registro no disponible en modo demo. Configure Supabase primero.' 
        });
      }

      const { name, email, password, confirmPassword } = req.body;

      // Validaciones básicas
      if (!name || !email || !password || !confirmPassword) {
        return res.status(400).json({ 
          success: false, 
          message: 'Todos los campos son requeridos' 
        });
      }

      if (password !== confirmPassword) {
        return res.status(400).json({ 
          success: false, 
          message: 'Las contraseñas no coinciden' 
        });
      }

      if (password.length < 6) {
        return res.status(400).json({ 
          success: false, 
          message: 'La contraseña debe tener al menos 6 caracteres' 
        });
      }

      // Verificar si el usuario ya existe
      const { data: existingUser } = await supabase
        .from('users')
        .select('email')
        .eq('email', email)
        .single();

      if (existingUser) {
        return res.status(409).json({ 
          success: false, 
          message: 'Este email ya está registrado' 
        });
      }

      // Encriptar contraseña
      const hashedPassword = await bcrypt.hash(password, 10);

      // Crear usuario en Supabase
      const { data: newUser, error } = await supabase
        .from('users')
        .insert([
          {
            name: name,
            email: email,
            password: hashedPassword,
            role: 'user',
            created_at: new Date().toISOString()
          }
        ])
        .select()
        .single();

      if (error) {
        console.error('Error al crear usuario:', error);
        return res.status(500).json({ 
          success: false, 
          message: 'Error al crear el usuario' 
        });
      }

      res.json({ 
        success: true, 
        message: 'Usuario creado exitosamente',
        redirectUrl: '/login'
      });

    } catch (error) {
      console.error('Error en registro:', error);
      res.status(500).json({ 
        success: false, 
        message: 'Error interno del servidor' 
      });
    }
  }

  // Cerrar sesión
  static async logout(req, res) {
    req.session.destroy((err) => {
      if (err) {
        return res.status(500).json({ 
          success: false, 
          message: 'Error al cerrar sesión' 
        });
      }
      res.redirect('/');
    });
  }
}

module.exports = AuthController;
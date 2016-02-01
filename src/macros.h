#ifndef MACROS_H_
#define MACROS_H_

#ifndef DEFINE_Q_PROPERTY
#define DEFINE_Q_PROPERTY(type, name)\
    Q_PROPERTY(type name READ name WRITE set_##name NOTIFY name##Changed)\
    public:\
      type name() const { return m_##name; } \
      void set_##name(const type& val) { \
        if (val != m_##name) { \
          m_##name = val; \
          emit name##Changed(m_##name);\
        }\
      }\
    private:\
      type m_##name
#endif

#endif //MACROS_H_

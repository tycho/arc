/*
 *  ARC++
 *
 *  Copyright (c) 2007-2008 Steven Noonan.
 *
 *  Licensed under the New BSD License.
 *
 */

#ifndef __included_databuffer_h
#define __included_databuffer_h

//! A sort of basic string class, but can hold other types of data as well.
class DataBuffer
{
    protected:
        //! Indicates whether or not the DataBuffer was set to contain a string.
        bool m_isString;

        //! The internal memory buffer which contains the data.
        char *m_buffer;

        //! The size of the internal buffer.
        size_t m_size;
        
    public:
        //! The default constructor.
        DataBuffer ();

        /*!
            \param _initialCapacity Amount of memory to allocate for the internal buffer.
         */
        DataBuffer ( size_t _initialCapacity );

        /*!
            \param _initialString A string to put into the buffer.
         */
        DataBuffer ( const char *_initialString );

        /*!
            \param _initialData A pointer to the data which should be inside the buffer.
            \param _size The size of the data to be copied (in bytes).
         */
        DataBuffer ( const void *_initialData, size_t _size );

        //! The copy constructor.
        DataBuffer ( const DataBuffer &_initialData );

        //! The destructor.
        virtual ~DataBuffer ();
        
        //! Resize the data buffer while preserving the contents.
        virtual void resize ( size_t _capacity );

        //! Resize the data buffer, dropping existing contents.
        virtual void setSize ( size_t _capacity );

        //! Set the data buffer contents.
        virtual int setData ( const void *_newData, size_t _size );

        //! Set the data buffer contents.
        virtual int setDataString ( const char *_newData );
        
        //! Returns a pointer to the internal data buffer.
        virtual const char *getData() const;

        //! Returns the current buffer size, in bytes.
        virtual size_t getSize() const;

        virtual bool isString() const;

        //! Implicit assignment operator.
        DataBuffer &operator=  ( const DataBuffer &_buffer );

        bool operator>  ( const DataBuffer &_buffer ) const;
        bool operator>= ( const DataBuffer &_buffer ) const;
        
        bool operator<  ( const DataBuffer &_buffer ) const;
        bool operator<= ( const DataBuffer &_buffer ) const;
        
        bool operator== ( const DataBuffer &_buffer ) const;
        bool operator!= ( const DataBuffer &_buffer ) const;

        /*!
            \return Returns 'true' if the data buffer has been allocated.
         */
        inline bool operator! () const { return ( m_buffer == NULL ); }
        
        //! Returns a pointer to a given location in the data buffer.
        /*!
            \param _index The index of the data requested.
         */
        inline char &operator[] ( unsigned int _index ) {
                static char c = '\x0';
                if ( m_buffer && m_size > _index )
                    return m_buffer[_index];
                else
                    return c;
        }

        //! Returns a pointer to a given location in the data buffer.
        /*!
            \param _index The index of the data requested.
         */
        inline const char &operator[] ( unsigned int _index ) const {
                static const char c = '\x0';
                if ( m_buffer && m_size > _index )
                    return m_buffer[_index];
                else
                    return c;
        }
};

#endif

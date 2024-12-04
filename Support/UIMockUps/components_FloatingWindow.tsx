import React from 'react'

interface FloatingWindowProps {
  children: React.ReactNode
  className?: string
}

export const FloatingWindow: React.FC<FloatingWindowProps> = ({ children, className = '' }) => {
  return (
    <div className={`bg-black bg-opacity-30 backdrop-blur-md rounded-3xl p-6 shadow-lg ${className}`}>
      {children}
    </div>
  )
}


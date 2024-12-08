import React from 'react'
import { FloatingWindow } from './FloatingWindow'

export const LoadingScreen: React.FC = () => {
  return (
    <FloatingWindow className="flex items-center justify-center h-screen">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4 text-white">Vibes</h1>
        <div className="w-16 h-16 border-t-4 border-blue-500 border-solid rounded-full animate-spin mx-auto"></div>
      </div>
    </FloatingWindow>
  )
}


import React from 'react'
import { FloatingWindow } from './FloatingWindow'
import { Play, Pause, SkipBack, SkipForward, Volume2 } from 'lucide-react'

export const NowPlayingView: React.FC = () => {
  return (
    <div className="flex items-center justify-center h-screen">
      <div className="relative">
        <div className="w-64 h-64 bg-gradient-to-br from-purple-500 to-pink-500 rounded-lg shadow-lg transform rotate-3 absolute -top-2 -left-2"></div>
        <FloatingWindow className="w-64 h-64 flex flex-col justify-between p-4 relative z-10">
          <img src="/placeholder.svg?height=160&width=160" alt="Album cover" className="w-40 h-40 mx-auto rounded-md shadow-md" />
          <div className="text-center">
            <h2 className="text-xl font-bold text-white">Song Title</h2>
            <p className="text-sm text-gray-300">Artist Name</p>
          </div>
        </FloatingWindow>
      </div>
      <FloatingWindow className="ml-8 p-4 flex flex-col items-center">
        <div className="flex space-x-4 mb-4">
          <button className="text-white hover:text-blue-400"><SkipBack /></button>
          <button className="text-white hover:text-blue-400"><Play /></button>
          <button className="text-white hover:text-blue-400"><SkipForward /></button>
        </div>
        <div className="flex items-center space-x-2">
          <Volume2 className="text-white" />
          <input type="range" className="w-32" />
        </div>
      </FloatingWindow>
    </div>
  )
}


import React from 'react'
import { FloatingWindow } from './FloatingWindow'

export const SettingsView: React.FC = () => {
  return (
    <FloatingWindow className="w-full max-w-md mx-auto">
      <h1 className="text-2xl font-bold mb-6 text-white">Settings</h1>
      <div className="space-y-4">
        <div>
          <label htmlFor="particleIntensity" className="block text-sm font-medium text-gray-300 mb-1">
            Particle Effect Intensity
          </label>
          <input
            type="range"
            id="particleIntensity"
            min="0"
            max="100"
            className="w-full"
          />
        </div>
        <div>
          <label htmlFor="colorScheme" className="block text-sm font-medium text-gray-300 mb-1">
            Color Scheme
          </label>
          <select id="colorScheme" className="w-full bg-gray-700 text-white rounded-md">
            <option>Dynamic (Based on Album Art)</option>
            <option>Warm</option>
            <option>Cool</option>
            <option>Neon</option>
          </select>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-sm font-medium text-gray-300">Enable Haptic Feedback</span>
          <label className="switch">
            <input type="checkbox" />
            <span className="slider round"></span>
          </label>
        </div>
      </div>
    </FloatingWindow>
  )
}


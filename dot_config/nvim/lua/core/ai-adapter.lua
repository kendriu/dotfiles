-- Centralized AI adapter management
-- Handles automatic fallback from Copilot to Ollama on rate limit

local M = {}

-- State
M.state = {
	hostname = vim.fn.hostname(),
	preferred_adapter = nil,
	current_adapter = nil,
	fallback_triggered = false,
}

-- Initialize based on hostname
function M.init()
	local hostname = M.state.hostname
	
	-- Determine preferred adapter based on hostname
	if hostname == "MB-928298.local" then
		M.state.preferred_adapter = "copilot"
	else
		M.state.preferred_adapter = "ollama"
	end
	
	-- Set current adapter
	M.state.current_adapter = M.state.preferred_adapter
	
	return M.state.current_adapter
end

-- Get current adapter
function M.get_adapter()
	if not M.state.current_adapter then
		M.init()
	end
	return M.state.current_adapter
end

-- Check if should use Copilot
function M.should_use_copilot()
	return M.get_adapter() == "copilot"
end

-- Trigger fallback to Ollama
function M.trigger_fallback(reason)
	if M.state.current_adapter == "copilot" then
		M.state.current_adapter = "ollama"
		M.state.fallback_triggered = true
		
		vim.notify(
			"🤖 AI: " .. (reason or "Copilot unavailable") .. " Switching to Ollama (local)",
			vim.log.levels.WARN,
			{ title = "AI Adapter", timeout = 3000 }
		)
		
		-- Disable Copilot completions in blink
		vim.g.copilot_enabled = false
		
		-- Try to update CodeCompanion if loaded
		local ok, cc = pcall(require, "codecompanion")
		if ok and cc.config then
			cc.config.strategies.chat.adapter = "ollama"
			cc.config.strategies.inline.adapter = "ollama"
			cc.config.strategies.agent.adapter = "ollama"
			
			vim.notify(
				"AI: Switched to Ollama. Restart your last command to use local AI.",
				vim.log.levels.INFO
			)
		end
		
		-- Schedule auto-recovery after 10 minutes
		M.schedule_recovery()
		
		return true
	end
	return false
end

-- Schedule automatic recovery attempt
function M.schedule_recovery()
	vim.defer_fn(function()
		if M.state.fallback_triggered then
			vim.notify(
				"🔄 AI: Attempting to restore Copilot connection...",
				vim.log.levels.INFO,
				{ title = "AI Adapter" }
			)
			M.reset()
			
			-- Test if Copilot is back by checking if it's enabled
			vim.defer_fn(function()
				if M.should_use_copilot() then
					vim.notify(
						"✅ AI: Copilot connection restored",
						vim.log.levels.INFO,
						{ title = "AI Adapter" }
					)
				end
			end, 2000)
		end
	end, 600000) -- 10 minutes = 600,000 ms
end

-- Check if rate limit error
function M.is_rate_limit_error(err)
	if not err then
		return false
	end
	
	local err_str = tostring(err)
	return err_str:match("[Rr]ate limit")
		or err_str:match("429")
		or err_str:match("[Qq]uota")
		or err_str:match("[Tt]hrottl")
end

-- Enhanced: Check if any fallback-worthy error
function M.is_fallback_error(err)
	if not err then
		return false
	end
	
	local err_str = tostring(err)
	return err_str:match("[Rr]ate limit")
		or err_str:match("429")
		or err_str:match("[Qq]uota")
		or err_str:match("[Tt]hrottl")
		or err_str:match("timeout")
		or err_str:match("timed out")
		or err_str:match("connection refused")
		or err_str:match("502") -- Bad gateway
		or err_str:match("503") -- Service unavailable
		or err_str:match("ECONNREFUSED")
		or err_str:match("network error")
end

-- Reset to preferred adapter (call on restart)
function M.reset()
	M.state.current_adapter = M.state.preferred_adapter
	M.state.fallback_triggered = false
	
	if M.should_use_copilot() then
		vim.g.copilot_enabled = true
	end
end

-- Get status for display
function M.status()
	return {
		hostname = M.state.hostname,
		preferred = M.state.preferred_adapter,
		current = M.get_adapter(),
		fallback_triggered = M.state.fallback_triggered,
	}
end

return M
